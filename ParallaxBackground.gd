extends ParallaxBackground


# Declare member variables here. Examples:
export var SPEED = 10
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.scroll_base_offset += Vector2(delta * SPEED, 0)
