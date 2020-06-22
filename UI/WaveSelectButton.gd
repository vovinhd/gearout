extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var episode = "Demo" 
export var wave_index = 1 

# Called when the node enters the scene tree for the first time.
func _ready():
	var progress = persistent_progress.get_episode_stats(episode)
	if (!progress or not progress.wave_stats.has(str(wave_index)) and not progress.wave_stats.has(str(wave_index + -1))): 
		disabled = true

func _on_Button_pressed():
	episode_manager.start_episode(episode, wave_index)
