extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var wave_select_buttons : GridContainer = $Panel/MarginContainer/WaveSelectButtons
onready var episode_title_label = $EpisodeTitle
var select_button = preload("res://UI/WaveSelectButton.tscn")
export var episode = "Demo"
export(Texture) var preview: Texture = preload("res://UI/demo_preview.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	episode_title_label.text = episode
	var episodes = episode_manager.episodes[episode]
	for i in range(episodes.size()): 
		var button = select_button.instance() 
		button.text = str(i + 1) 
		button.wave_index = i + 1
		button.episode = episode
		wave_select_buttons.add_child(button)
		button.connect("pressed", self, "on_button_")

	$Preview.texture = preview



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartEpisodeButton_pressed():
	game_instance.set_arcade_mode(false)
	episode_manager.start_episode(episode)


func _on_ArcadeModeButton_pressed():
	game_instance.set_arcade_mode(true)
	episode_manager.start_episode(episode)
