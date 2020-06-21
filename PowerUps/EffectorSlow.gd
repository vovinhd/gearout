extends Node2D

func apply_effect():
	print("EffectorSlow")
	game_instance.set_default_paddle()
	game_instance.slow_ball()
