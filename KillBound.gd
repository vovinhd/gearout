extends Area2D

signal ball_destroyed

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_KillBound_body_entered(body):
	print(body.name)
	if body.name == "Ball":
		emit_signal("ball_destroyed")

