extends Node

var standalone = true
var current_episode = "Demo"
var wave_index = 0
var arcade_mode = false

class Episode: 
	var name: String = "Demo"
	var waves: Array = []
	
var episodes = {
		"Demo": [
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
		],
		"Episode1": [
			preload("res://Waves/Episode1/1-1.tscn"),
			preload("res://Waves/Episode1/1-2.tscn"),
			preload("res://Waves/Episode1/1-3.tscn"),
			preload("res://Waves/Episode1/1-4.tscn"),
			preload("res://Waves/Episode1/1-5.tscn"),
			preload("res://Waves/Episode1/1-6.tscn"),
			preload("res://Waves/Episode1/1-7.tscn"),
		]
	}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_current_episode():
	return episodes[current_episode]

func start_episode(episode, index = 1):
	print("Start ", episode, " at ", index)
	episode_manager.current_episode = episode 
	episode_manager.wave_index = index
	episode_manager.standalone = false
	Transition.transition_to("res://LevelContainer.tscn")
