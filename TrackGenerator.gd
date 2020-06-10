extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (NodePath) var target  # Assign the node this camera will follow.

onready var track_u = $Track
onready var track_d = $Track2

var mat_u
var mat_d

var offset = 0

export(float) var scroll_speed = 1



func _ready():
	mat_u = track_u.get_material()
	mat_d = track_d.get_material()


func _process(delta):
	if target:
		global_position = get_node(target).global_position

func scroll_tracks(u_delta): 
	offset += u_delta * scroll_speed
	mat_u.set_shader_param("u_offset", offset)
	mat_d.set_shader_param("u_offset", offset)
