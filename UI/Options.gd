extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var sfx_bus

# Called when the node enters the scene tree for the first time.
func _ready():
	sfx_bus = AudioServer.get_bus_index("SFX")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CheckFullscreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed


func _on_SFXVolumeSlider_value_changed(value):
	var new_vol = log(value) * 20
	print("Set SFX vol: ", new_vol)
	AudioServer.set_bus_volume_db(sfx_bus, new_vol)
