extends Node 

enum GAME_STATE {
	IN_MENU,
	PAUSED,
	RUNNING
}

# references 
var game_state = GAME_STATE.IN_MENU
var level_container
var current_wave 
var world
var paddle 
var balls

func _ready():
	balls = []
	balls.clear()

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
			print(ball.name)
			if "phase_out" in ball: ball.phase_out()

#	balls = []

func add_ball(ball): 
	balls.push_back(ball)
	return balls.size() - 1