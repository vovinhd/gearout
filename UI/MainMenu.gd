extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func load_game(): 
	get_tree().change_scene("res://LevelContainer.tscn")

func view_settings(): 
	pass 

func quit_game(): 
	get_tree().quit()

func _on_StartButton_pressed():
	load_game()

func _on_OptionsButton_pressed():
	view_settings()


func _on_ExitButton_pressed():
	quit_game()
