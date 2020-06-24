extends KinematicBody2D

signal ball_collided(ball)
signal block_destroyed(emitter)

# Declare member variables here. Examples:
export var hitPoints = 1
export var score = 100
var block_destroyed = false 
var last_multiplier = 1 
export(PackedScene) var powerup 

var powerups = [
	{
		"scene": preload("res://PowerUps/AcidPowerup.tscn"),
		"chance": 0.05
	},
	{
		"scene": preload("res://PowerUps/BallSaverPowerup.tscn"),
		"chance": 0.05
	},
	{
		"scene": preload("res://PowerUps/BombPowerup.tscn"),
		"chance": 0.05
	},
	{
		"scene": preload("res://PowerUps/ExtendPowerup.tscn"),
		"chance": 0.05
	},
	{
		"scene": preload("res://PowerUps/GunPowerup.tscn"),
		"chance": 0.05
	},
	{
		"scene": preload("res://PowerUps/MagnetPowerup.tscn"),
		"chance": 0.05
	},
	{
		"scene": preload("res://PowerUps/OneUpPowerup.tscn"),
		"chance": 0.1
	},
	{
		"scene": preload("res://PowerUps/ScorePowerup.tscn"),
		"chance": 0.2
	},
	{
		"scene": preload("res://PowerUps/SlowPowerup.tscn"),
		"chance": 0.1
	},
]

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
	emit_signal("block_destroyed", score * last_multiplier)
	for node in get_children():
		if(node.get_class() == "CollisionShape2D" || node.get_class() == "CollisionPolygon2D"):
			node.queue_free()
			#node.set_deferred("disabled", true)
	$Sprite.set_deferred("visible", false)
	if has_node("AnimationPlayer"): 
		$AnimationPlayer.play("Explode")
	if powerup:
		spawn_powerup()
	elif game_instance.arcade_mode:
		powerup = random_powerup()
		print(powerup)
		if(powerup != null):
			spawn_powerup()



func spawn_powerup(): 
	var p = powerup.instance()
	game_instance.world.call_deferred("add_child", p)
	p.set_deferred("global_position", global_position)
	
func random_powerup() -> PackedScene: 
	var _p = powerups[randi() % powerups.size()]
	var _r = randf()
	#print("random powerup: ", _p, _r)
	return _p.get("scene") if _r <= _p.get("chance") else null
	
