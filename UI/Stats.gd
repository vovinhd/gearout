extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var stats = game_instance.last_stats
	if stats != null: 
		$Menu/MainMenu/HBoxContainer/Stats/TotalScore.text ="%07d" % stats.score
		$Menu/MainMenu/HBoxContainer/Stats/TotalTime.text = format_time(stats.total_play_time)
		$Menu/MainMenu/HBoxContainer/Stats/TotalRestarts.text = "%d" %  stats.balls_lost


func format_time(time: float) -> String:
	var minutes = time / 60
	var seconds = fmod(time, 60)
	return "%d" % minutes + ":" +"%02d" % seconds

func _on_Backbutton_pressed():
	Transition.transition_to("res://UI/MainMenu.tscn")
