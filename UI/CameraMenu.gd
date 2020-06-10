extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var acc = PI/2
export var MAX_SWAY = 10
export var SPEED = .1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	acc += delta
	position.x += sin(acc*SPEED) * MAX_SWAY
	pass
