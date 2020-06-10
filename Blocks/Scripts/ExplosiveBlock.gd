extends KinematicBody2D

class_name ExplosiveBlock

signal ball_collided(ball)
signal block_destroyed

# Declare member variables here. Examples:
export var hitPoints = 1
export var score = 100
var block_destroyed = false 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	pass


func _on_ball_collided(ball):
	self.hitPoints -= ball.damage
	print(("Hit {name}, hitPoints: {hp}".format({"name": self.name, "hp": self.hitPoints})))
	if(self.hitPoints <= 0): 
		self.destroy()
	pass # Replace with function body.

func destroy(): 
	self.block_destroyed = true
	for node in get_children():
		if(node.get_class() == "CollisionShape2D" || node.get_class() == "CollisionPolygon2D"):
			node.set_deferred("disabled", true)
	$Sprite.visible = false
	if $AnimationPlayer: 
		$AnimationPlayer.play("Explode")
	emit_signal("block_destroyed", self)

func apply_radial_damage():
	print("Boom")

func on_ExplosionArea_body_entered(node): 
	print("destroy ", body.name)