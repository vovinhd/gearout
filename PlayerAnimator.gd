extends Node2D

onready var top_holder = $HolderTop
onready var bottom_holder = $HolderBottom
onready var chain_f = $Chain
onready var chain_b = $Chain2
onready var paddle = $Paddle


var mat_f
var mat_b
var offset = 0

export(float) var scroll_speed = 1

func _ready():
	mat_f = chain_f.get_material()
	mat_b = chain_b.get_material()
	paddle.connect("paddle_moved", self, "animate_chains")

func animate_chains(amount, _y):
	top_holder.chain(amount)
	bottom_holder.chain(amount)

	offset += amount * scroll_speed
	mat_f.set_shader_param("v_offset", offset)
	mat_b.set_shader_param("v_offset", offset)
