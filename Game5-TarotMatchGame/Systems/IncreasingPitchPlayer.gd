extends AudioStreamPlayer

export (float) var increment

# Play with pitch level (1 to x, 1 being pitch = 1 - no alteration)
func play_increasing(level : int):
	pitch_scale = 1 + (level - 1) * increment
	stop()
	play()
