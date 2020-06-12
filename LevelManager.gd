extends Node2D

var score = 0
export var playerLives = 3
export var wave_transition_speed = .5
signal wave_completed
signal can_start_next_wave
signal scroll_speed(scrollspeed)
signal wave_instanced
export(Array, PackedScene) var wave_array = [
#	preload("res://Waves/Wave06.tscn"),
#	preload("res://Waves/Wave05.tscn"),
#	preload("res://Waves/Wave04.tscn"),
#	preload("res://Waves/Wave03.tscn"),
#	preload("res://Waves/Wave02.tscn"),
#	preload("res://Waves/Wave01.tscn"),
#	preload("res://Waves/Test01.tscn"),
#	preload("res://Waves/Test02.tscn"),
	preload("res://Waves/Test03.tscn"),
	preload("res://Waves/Test_Reactor.tscn"),
	preload("res://Waves/Test04.tscn"),
]

export var wave_index = 0

export var offset = Vector2.ZERO;

var old_world_position = Vector2.ZERO
var t = 0
var stopped = true
onready var world = $world
onready var track_generator = $TrackGenerator
onready var top_holder = $world/HolderTop
onready var bottom_holder = $world/HolderBottom
onready var kill_bound = $world/Bounds/KillBound

onready var lives_label = $InGameUI/MarginContainer/HBoxContainer/LivesLabel
var lives_format = "Lives: %d"
onready var wave_label = $InGameUI/MarginContainer/HBoxContainer/WaveLabel
var waves_format = "Wave: %d"
onready var score_label = $InGameUI/MarginContainer/HBoxContainer/ScoreLabel
var score_format = "Score: %07d"

var loader_thread : Thread = null

func _ready():
	game_instance.level_container = self

	self.connect("scroll_speed", track_generator, "scroll_tracks")
	self.connect("scroll_speed", self, "scroll_holders")
	self.connect("can_start_next_wave", get_node("world/Paddle"), "reset")
	self.connect("wave_completed", get_node("world/Paddle"), "wave_transition")
	kill_bound.connect("ball_destroyed", self, "_on_ball_destroyed")
	lives_label.text = lives_format % playerLives
	load_next_wave()

func load_next_wave():
	loader_thread = Thread.new()
	loader_thread.start(self, "thread_load_and_instance",wave_array[wave_index])

func thread_load_and_instance(packed_scene): 
	var current_wave = packed_scene.instance()
	game_instance.current_wave = current_wave

	wave_index = (wave_index + 1) % wave_array.size()
	print(wave_index, current_wave.name)
	if wave_index == 0: 
		wave_label.text = "Final Wave!"
	else:
		wave_label.text = waves_format % (wave_index)
	self.call_deferred("add_child", current_wave)
	current_wave.set_deferred("position", offset)
	current_wave.connect("wave_completed", self, "_on_wave_completed")
	emit_signal("wave_instanced")

func _on_wave_completed(): 
	emit_signal("wave_completed")
	print("Level complete")
	old_world_position = world.position
	t = 0 
	offset += Vector2(600, 0)
	stopped = false
	load_next_wave()
	game_instance.clear_balls()

func _physics_process(delta):
	if stopped:
		return
	t = clamp(t + delta * wave_transition_speed,0 ,1)
	emit_signal("scroll_speed", t)
	#track_generator.scroll_tracks(t)
	world.position = old_world_position.linear_interpolate(offset, t) 
	if t >= 1: 
		emit_signal("can_start_next_wave")
		stopped = true

func scroll_holders(speed): 
	top_holder.animate(speed)
	bottom_holder.animate(speed)
	pass

func _on_balls_destroyed():
	if !stopped: return
	print("All balls lost!")
	playerLives -= 1 
	if(playerLives <= 0): 
		print("you lose")
		playerLives = 3
	lives_label.text = lives_format % playerLives

func _on_ball_destroyed(_any):
	return

func add_score(emitter): 
	# if "last_multiplier" in emitter: 
	# 	score += emitter.score * emitter.last_multiplier;
	# else:
	score += emitter.score;
	score_label.text = score_format % score
