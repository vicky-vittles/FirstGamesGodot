extends Node

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

onready var camera = get_parent()

var amplitude = 0
var priority = 0

func start(duration = 0.2, frequency = 15, amplitude = 4, priority = 0):
	
	if priority >= self.priority:
		self.amplitude = amplitude
		self.priority = priority
		
		$Duration.wait_time = duration
		$Frequency.wait_time = 1 / float(frequency)
		
		$Duration.start()
		$Frequency.start()
		
		new_shake()

func new_shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	
	$Tween.interpolate_property(camera, "offset", camera.offset, rand, $Frequency.wait_time, TRANS, EASE)
	$Tween.start()

func reset():
	$Tween.interpolate_property(camera, "offset", camera.offset, Vector2(), $Frequency.wait_time, TRANS, EASE)
	$Tween.start()

func _on_Frequency_timeout():
	new_shake()

func _on_Duration_timeout():
	reset()
	$Frequency.stop()
