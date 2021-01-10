extends AudioStreamPlayer

export (Array, AudioStream) var samples

func _ready():
	randomize()

func play_random():
	if samples.size() > 0:
		var rand_index = randi() % samples.size()
		stop()
		stream = samples[rand_index]
		play()
