extends Node2D

func _ready():
	$AnimationPlayer.play("Explode")

func _on_ExplosionArea_body_entered(body):
	if (body.has_method("destroy")): 
		body.destroy()

