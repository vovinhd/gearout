extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# bound movement
var Y_MIN = 32
var Y_MAX = 320
signal paddle_moved(delta_y, y)

var last_mouse = Vector2.ZERO
export var speed = 300
export var slow_speed = 150
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

var BALL = preload("res://Ball.tscn")
onready var ball

onready var animation_player = $AnimationPlayer

const PADDLE_STATE = Enums.PADDLE_STATE

var paddle_state = PADDLE_STATE.BALL_LOST

# Called when the node enters the scene tree for the first time.
func _ready():
	game_instance.paddle = self

	rot_r = [lg_top,sg_bottom,sg_bottom_back]
	rot_l = [lg_bottom, sg_top_back, sg_top]


func _input(_event):
	if (Input.is_action_just_pressed("Fire")):
		match paddle_state: 
			PADDLE_STATE.BALL_LOST:
				_prepare_ball()
			PADDLE_STATE.BALL_PREPARING, PADDLE_STATE.WAVE_TRANSITION:
				pass
			PADDLE_STATE.BALL_WAITING:
				_fire_ball()
			PADDLE_STATE.BALL_ACTIVE:
				pass


func _prepare_ball(): 

	ball = BALL.instance()
	game_instance.world.add_child(ball)
	#ball.connect("ball_lost", self, "reset")
	self.connect("paddle_moved", ball, "paddle_moved")

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
	$AudioStreamPlayer.play()
	paddle_state = PADDLE_STATE.BALL_ACTIVE


var ball_offset = 0
func _physics_process(delta) -> void: 
	
	var current_mouse : Vector2 = get_global_mouse_position()
	
	if(current_mouse != last_mouse):
		self.position = Vector2(self.position.x, clamp(current_mouse.y, Y_MIN, Y_MAX))
		last_mouse = current_mouse
	else:
		var input = Vector2.ZERO
		var slow = false
		if Input.is_action_pressed("Up"):
			input.y -= 1 
		if Input.is_action_pressed("Down"): 
			input.y += 1
		if Input.is_action_pressed("slow"):
			slow = true
		if input.y != 0: 
				self.position = Vector2(self.position.x, clamp(self.position.y + input.y * delta * (slow_speed if slow else speed) , Y_MIN, Y_MAX))
		
	emit_signal("paddle_moved", position.y - last_position.y, position.y)
	
	var gear_roatation = fmod((position.y - last_position.y) * ROTATION_SPEED, 360)
	for gear in rot_r: 
		gear.rotation_degrees += gear_roatation
	for gear in rot_l: 
		gear.rotation_degrees -= gear_roatation

	if paddle_state == PADDLE_STATE.BALL_PREPARING:
		ball_offset += delta * 0.25
		ball.global_position = ball.global_position.linear_interpolate($BallFirePosition.global_position, ball_offset)
	last_position = self.position
#	pass


func reset(_any = null):
	animation_player.play("Reset")
	paddle_state = PADDLE_STATE.BALL_LOST
	ball_offset = 0

func wave_transition(): 
	paddle_state = PADDLE_STATE.WAVE_TRANSITION
