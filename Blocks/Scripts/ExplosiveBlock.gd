extends KinematicBody2D

signal ball_collided(ball)
signal block_destroyed
signal shake_camera(amount)

export var shake_amount = .1

# Declare member variables here. Examples:
export var hitPoints = 1
export var score = 200
var block_destroyed = false 
var last_multiplier = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	if (self.connect("shake_camera", get_tree().get_root().get_node("LevelContainer/Camera2D"), "add_trauma")): 
		print("Error connecting to shake_camera.")
	if (self.connect("block_destroyed", get_tree().get_root().get_node("LevelContainer"), "add_score")): 
		print("Error connecting to block_destroyed.")

func _on_ball_collided(ball):
	self.hitPoints -= ball.damage
	if(self.hitPoints <= 0): 
		self.destroy()
	pass # Replace with function body.

func destroy(): 
	if block_destroyed: return 
	self.block_destroyed = true
	for node in get_children():
		if(node.get_class() == "CollisionShape2D" || node.get_class() == "CollisionPolygon2D"):
			node.set_deferred("disabled", true)
	$Sprite.visible = false
	if $AnimationPlayer: 
		$AnimationPlayer.play("Explode")
	emit_signal("block_destroyed", score * last_multiplier)
	emit_signal("shake_camera", shake_amount)

func apply_radial_damage():
	pass
	
func _on_ExplosionArea_body_entered(body):
	if (body.has_method("destroy")): 
		body.destroy()
