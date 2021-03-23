extends AudioStreamPlayer

export (float) var min_pitch = 0.9
export (float) var max_pitch = 1.0

func _ready():
	assert(min_pitch < max_pitch)

func play_pitched():
	var pitch_range = max_pitch - min_pitch
	var rand_pitch = min_pitch + (randf()*pitch_range)
	print(rand_pitch)
	pitch_scale = rand_pitch
	play()
