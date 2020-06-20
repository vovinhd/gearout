extends Node 

enum GAME_STATE {
	IN_MENU,
	PAUSED,
	RUNNING
}

signal ball_state(ball_state)
signal ball_speed(ball_speed)
signal paddle_power(paddle_power)

# references 
var game_state = GAME_STATE.IN_MENU
var level_container
var last_stats
var current_wave 
var world
var paddle 
var balls : Array = Array()
var ball_speed = 400
var bomb_counter = 5
const BALL_STATE = Enums.BALL_STATE
const PADDLE_POWER = Enums.PADDLE_POWER
func _ready():
	print("Running on platform ", OS.get_name())

func _input(event):
	if event is InputEventKey:
		if event.alt:	
			if event.scancode == KEY_F4:
				get_tree().quit()
			if event.pressed and event.scancode == KEY_ENTER: 
				OS.window_fullscreen = !OS.window_fullscreen

#------------------------
#	balls
#------------------------

func _on_ball_lost(ball): 
	balls.erase(ball)
	ball.phase_out()
	for ball in balls: 
		if !is_instance_valid(ball):
			balls.erase(ball)
	if balls.size() == 0: 
		level_container._on_balls_destroyed()
		paddle.reset(null)

func clear_balls_sync(): 
	for ball in balls:
		if is_instance_valid(ball):
			ball.queue_free()
	balls = []
func clear_balls(): 
	for ball in balls:
		if is_instance_valid(ball):
			balls.erase(ball)
			if ball is Ball:
				 ball.phase_out()
			else: 
				print("Found non ball entity in balls array ", ball.name)

func add_ball(ball): 
	balls.push_back(ball)
	return balls.size() - 1

func set_acid_ball(): 
	emit_signal("ball_state", BALL_STATE.ACID)

func set_bomb_ball(): 
	bomb_counter = 5
	emit_signal("ball_state", BALL_STATE.BOMB)

func set_default_ball(): 
	emit_signal("ball_state", BALL_STATE.DEFAULT)

func sub_bomb(): 
	bomb_counter -= 1
	print("Blasts remaining ", bomb_counter)
	if bomb_counter <= 0: 
		set_default_ball()

func set_ball_speed(speed): 
	ball_speed = speed
	print("Ballspeed set to ", ball_speed)
	emit_signal("ball_speed", speed)
	
#------------------------
#	paddle
#------------------------

func set_extended_paddle(): 
	emit_signal("paddle_power", PADDLE_POWER.EXTEND)

func set_magnetic_paddle(): 
	emit_signal("paddle_power", PADDLE_POWER.MAGNET)
	
func set_gun_paddle(): 
	emit_signal("paddle_power", PADDLE_POWER.GUN)
	
func set_default_paddle(): 
	emit_signal("paddle_power", PADDLE_POWER.DEFAULT)
