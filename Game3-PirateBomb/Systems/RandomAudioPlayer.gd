extends AudioStreamPlayer

export (Array, AudioStream) var audio_files

func _ready():
	randomize()

func play_random():
	if audio_files.size() != 0:
		var index = randi() % audio_files.size()
		stop()
		stream = audio_files[index]
		play()
