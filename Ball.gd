extends KinematicBody2D

signal ball_lost
const PADDLE_STATE = PaddleState.PADDLE_STATE

onready var animation_player = $AnimationPlayer
onready var direction = Vector2(1, 0)
var paddle = null
export(float) var speed = 400.0
var enabled = false
var damage = 1
var paddle_y = 0
const MAX_Y_DIFF = 20
# Called when the node enters the scene tree for the first time.
func _ready():

	get_tree().get_root().get_node("LevelContainer/world/Bounds/KillBound").connect("ball_destroyed", self, "on_kill")
	get_tree().get_root().get_node("LevelContainer").connect("wave_completed", self, "phase_out")

	paddle = get_tree().get_root().get_node("LevelContainer/world/Paddle")
	print(paddle)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if paddle.paddle_state != PADDLE_STATE.BALL_ACTIVE:
		return
	var velocity = direction * speed
	var update = velocity * delta
	var collision = move_and_collide(update)
	
	if collision: 
		var normal = collision.normal
		match (collision.collider.name):
			"Top", "Bottom":
				update = normal.slide(update.normalized())
				move_and_collide(update)
				direction = -direction.reflect(normal)
				if(abs(direction.x) < 0.2):
					direction = Vector2(sign(direction.x) * 0.2, direction.y)
			"Paddle":
				update = normal.slide(update.normalized())
				move_and_collide(update)
				direction = Vector2(1, (position.y - paddle_y)/MAX_Y_DIFF)

			_: 
				update = normal.slide(update.normalized())
				move_and_collide(update)
				direction = -direction.reflect(normal)
		
		# tell other collider we hit it
		if(collision.collider.has_method("_on_ball_collided")):
			collision.collider._on_ball_collided(self)
		#	pass

func on_kill():
	print("kill ball")
	emit_signal("ball_lost")
	_reset_ball()

func phase_out(): 
	print("Level complete resetting ball")
	_reset_ball()

func _reset_ball(): 
	animation_player.play("PhaseOut")
	enabled = false

func phase_in(): 
	animation_player.play("PhaseIn")

func paddle_moved(delta_y, y):
	paddle_y = y
	if paddle:
		if paddle.paddle_state == PADDLE_STATE.BALL_PREPARING:
			position.y = y
		elif paddle.paddle_state == PADDLE_STATE.BALL_WAITING:
			position.y = clamp(position.y, y-MAX_Y_DIFF,y+MAX_Y_DIFF)

func fire_ball():
	enabled = true
	damage = 1
	direction = Vector2(1, (position.y - paddle_y)/MAX_Y_DIFF)
	print(direction)
