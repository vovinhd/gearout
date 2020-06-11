extends KinematicBody2D

signal ball_collided(ball)
signal block_destroyed(emitter)

# Declare member variables here. Examples:
export var hitPoints = 1
export var score = 400
var collision_direction = Vector2(rand_range(-1, 1), rand_range(-1, 1))
var block_destroyed = false 

var BALL = preload("res://Ball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("block_destroyed", get_tree().get_root().get_node("LevelContainer"), "add_score")
	pass # Replace with function body.

func _process(delta):
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	pass


func _on_ball_collided(ball):
	self.hitPoints -= ball.damage
	print(("Hit {name}, hitPoints: {hp}".format({"name": self.name, "hp": self.hitPoints})))
	collision_direction = (ball.global_position - global_position).normalized()
	print(ball.global_position, global_position, collision_direction)
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
	
	var ball = BALL.instance()
	game_instance.world.add_child(ball)
	ball.global_transform = global_transform
	ball.direction = collision_direction

	#ball.connect("ball_lost", self, "reset")
	game_instance.paddle.connect("paddle_moved", ball, "paddle_moved")
	
	emit_signal("block_destroyed", self)
