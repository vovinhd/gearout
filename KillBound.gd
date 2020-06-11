extends Area2D

signal ball_destroyed(ball)

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
	if body.get_meta("type") == "ball":
		emit_signal("ball_destroyed", body)

