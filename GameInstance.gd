extends Node 

enum GAME_STATE {
	IN_MENU,
	PAUSED,
	RUNNING
}

signal ball_state(ball_state)

# references 
var game_state = GAME_STATE.IN_MENU
var level_container
var current_wave 
var world
var paddle 
var balls : Array = Array()
const BALL_STATE = Enums.BALL_STATE

func _on_ball_lost(ball): 
	balls.erase(ball)
	ball.phase_out()
#	for i in range(balls.size()-1): 
#		if !is_instance_valid(balls[i]):
#			balls.remove(i)
	if balls.size() == 0: 
		level_container._on_balls_destroyed()
		paddle.reset(null)

func clear_balls(): 
	for ball in balls:
		if is_instance_valid(ball):
			balls.erase(ball)
			if ball is Ball:
				 ball.phase_out()
			else: 
				print(ball.name)


#	balls = []

func add_ball(ball): 
	balls.push_back(ball)
	return balls.size() - 1

func set_acid_ball(): 
	emit_signal("ball_state", BALL_STATE.ACID)

func set_bomb_ball(): 
	emit_signal("ball_state", BALL_STATE.BOMB)

func set_default_ball(): 
	emit_signal("ball_state", BALL_STATE.DEFAULT)

	
