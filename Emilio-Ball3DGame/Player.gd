extends RigidBody

export (float) var movement_speed = 0.15

func _process(delta):
	if Input.is_action_pressed("left"):
		apply_central_impulse(Vector3(-movement_speed, 0, 0))
	elif Input.is_action_pressed("right"):
		apply_central_impulse(Vector3(movement_speed, 0, 0))
