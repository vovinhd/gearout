extends Node2D
class_name Wave

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var blocks = [] 
signal wave_completed

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("wave_completed", game_instance, "clear_balls")
	for node in get_children():
		if("block_destroyed" in node):
			blocks.push_back(node)
			node.connect("block_destroyed", self, "_on_block_destroyed")

func _on_block_destroyed(block):
	if(self._check_completed()):
		print("Won wave")
		if has_node("AnimationPlayer"):
			$AnimationPlayer.play("Out")
		emit_signal("wave_completed")
	
func _check_completed() -> bool: 
	for block in blocks:
		if !block.block_destroyed:
			return false
	return true


func remove_collision():
	if has_node("Border"): 
		$Border.queue_free()
