extends Node2D

var wave_score = 0
var wave_time = 0.0 
var wave_balls_lost = 0
var stats = {
	"score": 0,
	"wave_scores": [],
	"wave_times": [],
	"wave_balls_losts": [],
	"balls_lost": 0,
	"total_play_time": 0.0,
}

export var playerLives = 3
export var wave_transition_speed = .5

signal wave_completed
signal can_start_next_wave
signal scroll_speed(scrollspeed)
signal wave_instanced

export(Array, PackedScene) var wave_array = [
	preload("res://Waves/Demo/Demo01.tscn"),
	preload("res://Waves/Demo/Demo02.tscn"),
	preload("res://Waves/Demo/Demo10.tscn"),
	preload("res://Waves/Demo/Demo09.tscn"),
	preload("res://Waves/Demo/Demo05.tscn"),
	preload("res://Waves/Demo/Demo03.tscn"),
	preload("res://Waves/Demo/Demo06.tscn"),
	preload("res://Waves/Demo/Demo04.tscn"),
	preload("res://Waves/Demo/Demo07.tscn"),
	preload("res://Waves/Demo/Demo08.tscn"),
	preload("res://Waves/Test_Reactor.tscn"),
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
onready var animation_player = $AnimationPlayer

onready var lives_label = $InGameUI/MarginContainer/HSplitContainer/HBoxContainer/LivesLabel
var lives_format = "Balls lost: %d"
var lives_format_arcade = "Lives remaining: %d"
onready var wave_label = $InGameUI/MarginContainer/HSplitContainer/HBoxContainer/WaveLabel
var waves_format = "Wave: %d"
onready var score_label = $InGameUI/MarginContainer/HSplitContainer/HBoxContainer/ScoreLabel
var score_format = "Score: %07d"

var loader_thread : Thread = null

var showing_wave_stats = false
var current_wave
var last_wave

func _ready():
	if not episode_manager.standalone: 
		wave_array = episode_manager.get_current_episode()
		wave_index = int(episode_manager.wave_index)-1
	game_instance.level_container = self
	self.connect("scroll_speed", track_generator, "scroll_tracks")
	self.connect("scroll_speed", self, "scroll_holders")
	self.connect("can_start_next_wave", get_node("world/Paddle"), "reset")
	self.connect("wave_completed", get_node("world/Paddle"), "wave_transition")
	kill_bound.connect("ball_destroyed", self, "_on_ball_destroyed")
	if game_instance.arcade_mode: 
		lives_label.text = lives_format_arcade % game_instance.lives
	else:
		lives_label.text = lives_format % 0
	load_next_wave()
	animation_player.play("UIWaveStart")


func _input(event):
	if (Input.is_action_just_pressed("Fire")) && showing_wave_stats:
		_on_wave_stat_dismissed()
	if (Input.is_action_just_pressed("Pause")):
			_on_PauseButton_pressed()
			
func load_next_wave():

	if OS.get_name() == "HTML5": 
		thread_load_and_instance(wave_array[wave_index])
	else:
		loader_thread = Thread.new()
		print(loader_thread.start(self, "thread_load_and_instance",wave_array[wave_index]))
	if game_instance.arcade_mode:
		game_instance.set_ball_speed(min(wave_index * 10 + 250, 400))
	else: 
		game_instance.set_ball_speed(min(wave_index * 5 + 200, 350))


func thread_load_and_instance(packed_scene): 
	last_wave = current_wave
	current_wave = packed_scene.instance()
	game_instance.current_wave = current_wave

	#% wave_array.size()
	print("At wave:", wave_index, " name: ", current_wave.name)
#	if wave_index == 0: 
#		wave_label.text = "Final Wave!"
#	else:
	wave_label.text = waves_format % (wave_index +1)
	self.call_deferred("add_child", current_wave)
	current_wave.set_deferred("position", offset)
	current_wave.connect("wave_completed", self, "_on_wave_completed")
	emit_signal("wave_instanced")
	if OS.get_name() == "HTML5": 
		return
	elif loader_thread.is_active(): 
		loader_thread.wait_to_finish()

func _on_wave_completed(): 
	emit_signal("wave_completed")
	print("Level complete")
	game_instance.clear_balls()
	wave_index = (wave_index + 1) 
	_set_wave_stats()
	#stats.wave_scores.push_back(wave_score)
	#stats.wave_times.push_back(wave_time)
	#stats.wave_balls_losts.push_back(wave_balls_lost)
	#showing_wave_stats = true
	animation_player.play("UIShowWaveStats")
	#_on_wave_stat_dismissed()

func _set_wave_stats(): 
	stats.wave_scores.push_back(wave_score)
	stats.wave_times.push_back(wave_time)
	stats.wave_balls_losts.push_back(wave_balls_lost)
	
	if wave_index >= wave_array.size():
		game_instance.last_stats = stats 
		Transition.transition_to("res://UI/Stats.tscn")
	
	showing_wave_stats = true
	
	$WaveCompleted/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/WaveScore.text = "%07d" % wave_score
	$WaveCompleted/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/TotalScore.text ="%07d" % stats.score
	
	$WaveCompleted/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/WaveTime.text = format_time(wave_time)
	$WaveCompleted/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/TotalTime.text = format_time(stats.total_play_time)
	
	$WaveCompleted/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/WaveBalls.text =  "%d" % wave_balls_lost
	$WaveCompleted/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/TotalBalls.text = "%d" %  stats.balls_lost

	persistent_progress.add_wave_stat(
		wave_index,
		current_wave.name,
		episode_manager.current_episode, 
		wave_score,
		wave_time,
		wave_balls_lost
	)

func format_time(time: float) -> String:
	var minutes = time / 60
	var seconds = fmod(time, 60)
	return "%d" % minutes + ":" +"%02d" % seconds
	 
func _on_wave_stat_dismissed(): 
	wave_score = 0
	wave_balls_lost = 0
	wave_time = 0.0
	showing_wave_stats = false
	old_world_position = world.position
	stopped = false
	t = 0 
	offset += Vector2(600, 0)
	animation_player.play("UIHideAll")
	load_next_wave()


func _physics_process(delta):
	
	if stopped:
		wave_time += delta
		stats.total_play_time += delta
		return
	t = clamp(t + delta * wave_transition_speed,0 ,1)
	emit_signal("scroll_speed", t)
	#track_generator.scroll_tracks(t)
	world.position = old_world_position.linear_interpolate(offset, t) 
	if t >= 1: 
		game_instance.clear_balls()
		emit_signal("can_start_next_wave")
		animation_player.play("UIWaveStart")
		stopped = true
		if is_instance_valid(last_wave): 
			last_wave.queue_free() 

func scroll_holders(speed): 
	top_holder.animate(speed)
	bottom_holder.animate(speed)
	pass

func _on_balls_destroyed():
	if !stopped: return
	print("All balls lost!")
	wave_balls_lost += 1
	stats.balls_lost += 1
	$AudioStreamPlayer.play()
	game_instance.balls_lost()
	if game_instance.arcade_mode: 
		lives_label.text = lives_format_arcade % game_instance.lives
	else:
		lives_label.text = lives_format % stats.balls_lost


func _on_ball_destroyed(_any):
	return

func add_score(score): 
	# if "last_multiplier" in emitter: 
	# 	score += emitter.score * emitter.last_multiplier;
	# else:
	stats.score += score
	wave_score += score
	score_label.text = score_format % stats.score


func _on_PauseButton_pressed():
	animation_player.play("Pause")
	$PauseMenu/Control/MarginContainer/VBoxContainer/Button.grab_focus()
	self.get_tree().paused = true


func _on_UnpauseButton_pressed():
	self.get_tree().paused = false
	animation_player.play("Unpause")



func _on_RestartWaveButton_pressed():
	current_wave.queue_free()
	game_instance.clear_balls_sync()
	thread_load_and_instance(wave_array[wave_index])
	game_instance.paddle.paddle_state = Enums.PADDLE_STATE.BALL_LOST
	
	

