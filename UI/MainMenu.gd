extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var options_offset = 640


func _ready():
	$Menu/MainMenu/VBoxContainer/StartButton.grab_focus()

func _input(event):
	if event.is_action("ui_cancel"):
		_on_Backbutton_pressed()

func load_game(): 
	if persistent_progress.has_progress(): 
		Transition.transition_to("res://UI/LevelSelect.tscn")
	else:
		episode_manager.start_episode("Demo")

func view_settings(): 
	$AnimationPlayer.play("ViewSettings")
	$Menu/Backbutton.grab_focus()

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
	$Menu/MainMenu/VBoxContainer/StartButton.grab_focus()


func _on_URLButton_pressed():
	OS.shell_open("https://vovin.itch.io")
