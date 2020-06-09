extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# bound movement
var Y_MIN = 32
var Y_MAX = 320
signal paddle_moved(delta_y, y)

# setup gear rotation
var last_position = Vector2.ZERO
var rot_r
var rot_l
const ROTATION_SPEED = 1
onready var lg_top = $Sprite/LargeGear
onready var lg_bottom = $Sprite/LargeGear2
onready var sg_top = $Sprite/SmallGear3
onready var sg_top_back = $Sprite/SmallGear
onready var sg_bottom = $Sprite/SmallGear4
onready var sg_bottom_back = $Sprite/SmallGear2


onready var ball

onready var animation_player = $AnimationPlayer

# play state 

const PADDLE_STATE = PaddleState.PADDLE_STATE


var paddle_state = PADDLE_STATE.BALL_LOST

# Called when the node enters the scene tree for the first time.
func _ready():
	rot_r = [lg_top,sg_bottom,sg_bottom_back]
	rot_l = [lg_bottom, sg_top_back, sg_top]

	ball  = get_tree().get_root().get_node("LevelContainer/world").find_node("Ball")
	print(ball)
	ball.connect("ball_lost", self, "reset")
	self.connect("paddle_moved", ball, "paddle_moved")

func _input(_event):
	if (Input.is_action_just_pressed("Fire")):
		match paddle_state: 
			PADDLE_STATE.BALL_LOST:
				_prepare_ball()
			PADDLE_STATE.BALL_PREPARING:
				pass
			PADDLE_STATE.BALL_WAITING:
				_fire_ball()
			PADDLE_STATE.BALL_ACTIVE:
				pass


func _prepare_ball(): 

	ball.global_transform = $BallSpawnPosition.global_transform
	animation_player.play("PrepareBall")
	ball.phase_in()
	paddle_state = PADDLE_STATE.BALL_PREPARING
	pass

func _ball_ready():
	paddle_state = PADDLE_STATE.BALL_WAITING
	ball.global_transform = $BallFirePosition.global_transform


func _fire_ball():
	ball.fire_ball()
	paddle_state = PADDLE_STATE.BALL_ACTIVE

func _process(_delta) -> void: 
	var current_mouse : Vector2 = get_global_mouse_position()
	self.position = Vector2(self.position.x, clamp(current_mouse.y, Y_MIN, Y_MAX))
	
	emit_signal("paddle_moved", position.y - last_position.y, position.y)
	
	var gear_roatation = fmod((position.y - last_position.y) * ROTATION_SPEED, 360)
	for gear in rot_r: 
		gear.rotation_degrees += gear_roatation
	for gear in rot_l: 
		gear.rotation_degrees -= gear_roatation


	
	last_position = self.position
#	pass

func reset():
	animation_player.play("Reset")
	paddle_state = PADDLE_STATE.BALL_LOST
