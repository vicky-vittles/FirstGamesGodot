extends AudioStreamPlayer

export (Array, AudioStream) var audios

func play_random():
	if not playing:
		if audios.size() > 0:
			var rand_index = randi() % audios.size()
			stream = audios[rand_index]
			play()
