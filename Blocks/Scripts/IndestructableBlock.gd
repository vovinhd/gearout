extends KinematicBody2D

signal ball_collided(ball)
signal block_destroyed(emitter)

# Declare member variables here. Examples:
export var hitPoints = 1
export var score = 100
var block_destroyed = false 
var last_multiplier = 1 
export(PackedScene) var powerup 

# Called when the node enters the scene tree for the first time.
func _ready():
	if(self.connect("block_destroyed", get_tree().get_root().get_node("LevelContainer"), "add_score")):
		print("Error connecting to block_destroyed")

func _on_ball_collided(ball):
	last_multiplier = ball.multiplier
	self.hitPoints -= ball.damage
	if(self.hitPoints <= 0): 
		self.destroy()
	pass

func destroy(): 	
	if block_destroyed: return 
	self.block_destroyed = true
	for node in get_children():
		if(node.get_class() == "CollisionShape2D" || node.get_class() == "CollisionPolygon2D"):
			node.set_deferred("disabled", true)
	$Sprite.visible = false
	if has_node("AnimationPlayer"): 
		$AnimationPlayer.play("Explode")
	if powerup:
		var p = powerup.instance()
		game_instance.world.call_deferred("add_child", p)
		p.set_deferred("global_position", global_position)
	emit_signal("block_destroyed", score * last_multiplier)
