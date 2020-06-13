extends CanvasLayer

var path = ""
var target: Vector2 = Vector2.ZERO

func transition_to(scn_path):
	path = scn_path; 
	$AnimationPlayer.play("CircleFade")
	
func _change_scene(): 
	if path != "": 
		get_tree().change_scene(path)

func set_center(target_node):
	target = target_node.get_viewport_transform().origin
