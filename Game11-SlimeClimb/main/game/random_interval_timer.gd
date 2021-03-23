extends Timer

export (float) var min_wait_time = 3.0
export (float) var max_wait_time = 5.0

func _ready():
	assert(min_wait_time < max_wait_time)

func _on_WaterDripTimer_timeout():
	var wait_time_range = max_wait_time-min_wait_time
	var next_wait_time = min_wait_time+(randf()*(wait_time_range))
	wait_time = next_wait_time
	start()
