extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var direction = 1
export var ROTATION_SPEED = 10000
onready var lg_l = $Housing/LargeGear
onready var lg_r = $Housing/LargeGear2
onready var mi = $Housing/MovingIndicator
onready var sg_ul = $Housing/SmallGear
onready var sg_ur = $Housing/SmallGear2
onready var sg_lr = $Housing/SmallGear3
onready var sg_ll = $Housing/SmallGear4
onready var sg_chain = $Housing/SmallGear5

var rot_r
var rot_l
var last_amount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	rot_r = [lg_l, sg_lr, sg_ur]
	rot_l = [lg_r, sg_ll, sg_ul]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func chain(amount): 
	sg_chain.rotation_degrees += amount
	pass

func animate(amount): 
	if (amount == 1): 
		mi.frame = 0
	else:
		mi.frame = 1
	
	var gear_roatation = fmod((amount - last_amount) * direction * ROTATION_SPEED, 360)
	
	for gear in rot_r: 
		gear.rotation_degrees += gear_roatation
	for gear in rot_l: 
		gear.rotation_degrees -= gear_roatation

	last_amount = amount
