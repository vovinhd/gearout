extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Menu/SelectMenu/EpisodeSelect/Panel/MarginContainer/StartEpisodeButton.grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BackButton_pressed():
	Transition.transition_to("res://UI/MainMenu.tscn")
	pass # Replace with function body.
