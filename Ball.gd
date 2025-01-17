extends KinematicBody2D

class_name Ball
signal ball_lost(ball)
const PADDLE_STATE = Enums.PADDLE_STATE
const BALL_STATE = Enums.BALL_STATE
var ball_state = BALL_STATE.DEFAULT
var id = -1

var _explosion = preload("res://PowerUps/Explosion.tscn")

onready var animation_player = $AnimationPlayer
onready var audio = $AudioStreamPlayer
onready var direction = Vector2(1, 0)
var paddle = null
export(float) var speed = 400.0
var enabled = false
var damage = 1
var paddle_y = 0
var multiplier = 1
var last_collision_with_paddle = false
const MAX_Y_DIFF = 20
const EXTEND_DEFLECTION_FACTOR = 3
const ARCADE_MODE_SPEED_INCREASE = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("type", "ball")
	game_instance.add_ball(self)
	speed = game_instance.ball_speed
#	if (get_tree().get_root().get_node("LevelContainer/world/Bounds/KillBound").connect("ball_destroyed", self, "on_kill")):
#		print("Error connecting to LevelContainer/world/Bounds/KillBound")
	if (get_tree().get_root().get_node("LevelContainer").connect("wave_completed", self, "phase_out")): 
		print("Error connecting to LevelContainer")
	if (self.connect("ball_lost", game_instance, "_on_ball_lost")
		|| game_instance.connect("ball_state", self, "recieve_state")
		|| game_instance.connect("ball_speed", self, "recieve_speed")): 
		print("Error connecting to game_instance")
	paddle = game_instance.paddle
	
	pass # Replace with function body.

func recieve_state(new_ball_state): 
	ball_state = new_ball_state
	match ball_state: 
		BALL_STATE.DEFAULT: 
			animation_player.play("Default")
		BALL_STATE.ACID: 
			animation_player.play("Acid")
		BALL_STATE.BOMB: 
			animation_player.play("Bomb")

func recieve_speed(new_speed): 
	speed = new_speed

func magetic_attraction(direction_x, direction_y, paddle_y, position_y) -> Vector2:
	var distance = position_y - paddle_y
	var force = direction_y - distance
	var sum = abs(direction_x) + abs(force)
	var direction  = Vector2(direction_x, force/(sum * 5)).normalized()
	#print("dir_x: ", direction_x, " position_y: ", position_y, " paddle_y: ", paddle_y, " force: ", force, " direction: ", direction)
	return direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if paddle.paddle_state != PADDLE_STATE.BALL_ACTIVE:
		return
	if paddle.paddle_power == Enums.PADDLE_POWER.MAGNET:
		direction = magetic_attraction(direction.x, direction.y, paddle.position.y, position.y)
	var velocity = direction.normalized() * speed
	var update = velocity * delta
	var collision = move_and_collide(update)
	
	if collision: 
		var normal = collision.normal

		match (collision.collider.name):
			"Top", "Bottom":
				last_collision_with_paddle = false
				update = normal.slide(update.normalized())
				var _direction = move_and_collide(update)
				direction = -direction.reflect(normal)
#				if(abs(direction.x) < 0.2):
#					direction = Vector2(sign(direction.x) * 0.2, direction.y)
				audio.play(0.0)
			"Paddle":
				update = normal.slide(update.normalized())
				var _direction = move_and_collide(update)
				if(game_instance.paddle.paddle_power == Enums.PADDLE_POWER.EXTEND):
					direction = Vector2(1, (position.y - paddle_y)/(MAX_Y_DIFF * EXTEND_DEFLECTION_FACTOR))
				else:
					direction = Vector2(1, (position.y - paddle_y)/MAX_Y_DIFF)
				multiplier = 1
				audio.play(0.0)
				if (game_instance.arcade_mode && !last_collision_with_paddle): 
					last_collision_with_paddle = true
					game_instance.add_ball_speed(ARCADE_MODE_SPEED_INCREASE)
			_: 
				last_collision_with_paddle = false
				multiplier += 1				
				update = normal.slide(update.normalized())
				var _direction = move_and_collide(update)
				match ball_state:
					BALL_STATE.DEFAULT:
						direction = -direction.reflect(normal)
						# tell other collider we hit it
						if(collision.collider.has_method("_on_ball_collided")):
							collision.collider._on_ball_collided(self)
						else: 				
							audio.play(0.0)
					BALL_STATE.ACID:
						# tell other collider we hit it
						if(collision.collider.has_method("_on_ball_collided")):
							collision.collider._on_ball_collided(self)
						else:
							direction = -direction.reflect(normal)
							audio.play(0.0)
					BALL_STATE.BOMB:
						direction = -direction.reflect(normal)
						# tell other collider we hit it
						if(collision.collider.has_method("_on_ball_collided")):
							collision.collider._on_ball_collided(self)
							var explosion = _explosion.instance()
							game_instance.world.call_deferred("add_child", explosion)
							explosion.set_deferred("global_position", global_position)
							game_instance.sub_bomb()
						else:
							audio.play(0.0)
func on_kill(ball):
	if ball != self:
		return
	if paddle.paddle_state != PADDLE_STATE.BALL_ACTIVE:
		return
#	emit_signal("ball_lost", self)
	_reset_ball()

func phase_out(): 
#	emit_signal("ball_lost", self)
	_reset_ball()

func _reset_ball(): 
	animation_player.play("PhaseOut")
	enabled = false




func phase_in(): 
	animation_player.play("PhaseIn")

func paddle_moved(_delta_y, y):
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


func _on_AudioStreamPlayer_finished():
	#audio.playing = false
	pass # Replace with function body.
