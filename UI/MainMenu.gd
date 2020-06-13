extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var options_offset = 640


func load_game(): 
	Transition.transition_to("res://LevelContainer.tscn")


func view_settings(): 
	$AnimationPlayer.play("ViewSettings")

func quit_game(): 
	get_tree().quit()

func _on_StartButton_pressed():
	load_game()

func _on_OptionsButton_pressed():
	view_settings()


func _on_ExitButton_pressed():
	quit_game()

func _on_Backbutton_pressed():
	$AnimationPlayer.play("ViewMain")
