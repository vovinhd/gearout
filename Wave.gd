extends Node2D
class_name Wave

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float) var ball_base_speed = 400 
var blocks : Array= Array()
signal wave_completed
var cleared = false

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("wave_completed", game_instance, "clear_balls")
	#print(ball_base_speed)
	#game_instance.set_ball_speed(ball_base_speed)
	for node in get_children():
		if("block_destroyed" in node):
			blocks.push_back(node)
			node.connect("block_destroyed", self, "_on_block_destroyed")

func _on_block_destroyed(block):
	if cleared: return
	if(self._check_completed()):
		cleared = true
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
#	if has_node("Border"): 
#		$Border.queue_free()
	for node in get_children(): 
		if node.is_in_group("remove") || "Indestructable" in node.name:
			node.queue_free()
