extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var collected = false
onready var animation_player = $AnimationPlayer
export var speed = 150
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !collected:
		position.x -= speed * delta

func collect():
	animation_player.play("Collect")

func destroy():
	self.queue_free()

func _on_Sensor_area_entered(area):
	if area.name == "Killbound": 
		destroy()


func _on_Sensor_body_entered(body):
	if body.name == "Paddle": 
		collected = true
		apply_effect()
		collect()

func apply_effect(): 
	print("apply_effect")
	var effector = find_node("Effector") 
	if effector:
		effector.apply_effect()
	else: 
		print("PowerUp needs an Effector to do something!")
