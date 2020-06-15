extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	grab_focus()
	pass # Replace with function body.

func _input(event):
	if (Input.is_action_just_pressed("Pause")):
			game_instance.level_container._on_UnpauseButton_pressed()
