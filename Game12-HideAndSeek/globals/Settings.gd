extends Node

const MUSIC_CHANNEL = "Music"
const SOUND_CHANNEL = "Sound"

var music_volume : float = 0.3
var sound_volume : float = 0.5
var mouse_sensibility : float = 0.25

func change_music_volume(new_volume: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(MUSIC_CHANNEL),linear2db(new_volume))

func change_sound_volume(new_volume: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(SOUND_CHANNEL),linear2db(new_volume))

func change_mouse_sensibility(new_value: float):
	mouse_sensibility = new_value
