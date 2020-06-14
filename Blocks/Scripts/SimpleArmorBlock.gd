extends KinematicBody2D

signal ball_collided(ball)
signal block_destroyed(emitter)

# Declare member variables here. Examples:
export var hitPoints = 2
export var score = 100
var block_destroyed = false 
var last_multiplier = 1 

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("block_destroyed", get_tree().get_root().get_node("LevelContainer"), "add_score")
	pass # Replace with function body.

func _process(delta):
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	pass


func _on_ball_collided(ball):
	last_multiplier = ball.multiplier
	self.hitPoints -= ball.damage
	if(self.hitPoints <= 0): 
		self.destroy()
	else: 
		$AnimationPlayer.play("TakeDamage")

func destroy(): 	
	if block_destroyed: return 
	self.block_destroyed = true
	for node in get_children():
		if(node.get_class() == "CollisionShape2D" || node.get_class() == "CollisionPolygon2D"):
			node.set_deferred("disabled", true)
	$Sprite.visible = false
	if has_node("AnimationPlayer"): 
		$AnimationPlayer.play("Explode")
	emit_signal("block_destroyed", score * last_multiplier)
