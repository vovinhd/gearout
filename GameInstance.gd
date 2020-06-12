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
var balls = []

func _on_ball_lost(ball): 
	balls.erase(ball)
	for i in range(balls.size()-1): 
		if !is_instance_valid(balls[i]):
			balls.remove(i)
	if balls.size() == 0: 
		level_container._on_balls_destroyed()
		paddle.reset(null)

func clear_balls(): 
	for ball in balls:
		ball.phase_out()
	balls = []
