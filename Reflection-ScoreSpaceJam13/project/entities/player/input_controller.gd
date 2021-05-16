extends Node

onready var input = {
	"move_direction": Vector2.ZERO,
	"dash_press": false}

func clear_input():
	input["move_direction"] = Vector2.ZERO
	input["dash_press"] = false

func get_input():
	var move_direction = Vector2()
	move_direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	move_direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	move_direction = move_direction.normalized()
	var dash_press = Input.is_action_just_pressed("dash")
	input["move_direction"] = move_direction
	input["dash_press"] = dash_press
