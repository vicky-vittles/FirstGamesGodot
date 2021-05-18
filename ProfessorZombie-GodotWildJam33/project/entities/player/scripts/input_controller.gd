extends Node

var is_mouse_colliding : bool
var plus_press : bool
var plus_hold : bool
var minus_press : bool
var minus_hold : bool

func clear_input():
	plus_press = false
	plus_hold = false
	minus_press = false
	minus_hold = false

func get_input():
	plus_press = Input.is_action_just_pressed("plus")
	plus_hold = Input.is_action_pressed("plus")
	minus_press = Input.is_action_just_pressed("minus")
	minus_hold = Input.is_action_pressed("minus")

func set_is_mouse_colliding(value: bool):
	is_mouse_colliding = value
