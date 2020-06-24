extends Button

func _on_BackToMenuButton_pressed():
	self.get_tree().paused = false
	Transition.transition_to("res://UI/MainMenu.tscn")
