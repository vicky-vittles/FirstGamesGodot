extends "res://Screens/BaseScreen.gd"

signal go_to_title_screen()

onready var music_slider = $MarginContainer/VBoxContainer/Buttons/Sliders/MusicOptions/Music
onready var sound_slider = $MarginContainer/VBoxContainer/Buttons/Sliders/SoundOptions/Sound

func _ready():
	music_slider.value = Settings.volume[Settings.MUSIC_CHANNEL] * 100
	sound_slider.value = Settings.volume[Settings.SOUND_CHANNEL] * 100

func _on_Music_value_changed(value):
	Settings.change_music_slider(value)

func _on_Sound_value_changed(value):
	Settings.change_sound_slider(value)

func _on_Back_pressed():
	emit_signal("go_to_title_screen")
