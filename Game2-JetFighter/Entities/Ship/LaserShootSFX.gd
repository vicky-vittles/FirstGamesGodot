extends AudioStreamPlayer

export (Array, AudioStream) var audio_files

func _ready():
	randomize()

func play_random():
	var random_number = randi() % audio_files.size()
	stop()
	stream = audio_files[random_number]
	play()
