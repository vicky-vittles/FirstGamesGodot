extends Node

const MUSIC_CHANNEL = "Music"
const SOUND_CHANNEL = "Sound"

var volume = {"Music": 0.1, "Sound": 0.1}


func _ready():
	set_volume(MUSIC_CHANNEL, 0)
	set_volume(SOUND_CHANNEL, 0)

func change_music_slider(value):
	value /= 100
	set_volume(MUSIC_CHANNEL, value)

func change_sound_slider(value):
	value /= 100
	set_volume(SOUND_CHANNEL, value)

func set_volume(channel, value):
	volume[channel] = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(channel), linear2db(value))
