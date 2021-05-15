extends Node

func get_input():
	var move_direction = Vector2()
	move_direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	move_direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	move_direction = move_direction.normalized()
	var dash_press = Input.is_action_just_pressed("dash")
	var input = {
		"move_direction": move_direction,
		"dash_press": dash_press}
	return input
