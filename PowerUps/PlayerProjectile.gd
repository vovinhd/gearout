extends Node2D

var SPEED = 600
var direction = Vector2.RIGHT
var multiplier = 1
var damage = 10
func _physics_process(delta):
	var velocity = direction.normalized() * SPEED * delta
	position += velocity
	if position.x > 700: 
		queue_free()
	

func _on_Sensor_body_entered(body):
	if(body.has_method("_on_ball_collided")):
		body._on_ball_collided(self)
		queue_free()
