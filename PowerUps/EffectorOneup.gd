extends Node2D

func apply_effect():
	print("EffectorOneup")
	game_instance.set_default_paddle()
	game_instance.add_life()
