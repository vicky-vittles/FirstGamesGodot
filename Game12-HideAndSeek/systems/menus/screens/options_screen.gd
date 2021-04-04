extends "res://systems/menus/screens/_BaseScreen.gd"

signal go_to_title_screen()

onready var music_scroll = $root/center/options/buttons/music/VBoxContainer/MusicScroll
onready var sound_scroll = $root/center/options/buttons/sound/VBoxContainer/SoundScroll
onready var sensibility_scroll = $root/center/options/buttons/mouse_sensibility/VBoxContainer/SensibilityScroll

func _ready():
	music_scroll.value = Settings.music_volume
	sound_scroll.value = Settings.sound_volume
	sensibility_scroll.value = Settings.mouse_sensibility

func _on_MusicScroll_value_changed(value):
	Settings.change_music_volume(value)

func _on_SoundScroll_value_changed(value):
	Settings.change_sound_volume(value)

func _on_SensibilityScroll_value_changed(value):
	Settings.change_mouse_sensibility(value)
