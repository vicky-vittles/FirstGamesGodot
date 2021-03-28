extends Timer

signal match_time_update(time)

func _physics_process(delta):
	emit_signal("match_time_update", time_left)
