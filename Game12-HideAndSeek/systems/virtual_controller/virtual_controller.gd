extends Node

class_name VirtualController, "res://assets/icons/virtual-controller.svg"

enum PRESS_TYPE { PRESS, HOLD }

var input_pressed = {}
var input_hold = {}

func _ready():
	var all_actions = InputMap.get_actions()
	for action in all_actions:
		input_pressed[action] = false
		input_hold[action] = false


# Public
func get_press(action_name: String):
	return get_action(action_name, PRESS_TYPE.PRESS)

func get_hold(action_name: String):
	return get_action(action_name, PRESS_TYPE.HOLD)

func set_press(action_name: String, value):
	set_action(action_name, value, PRESS_TYPE.PRESS)

func set_hold(action_name: String, value):
	set_action(action_name, value, PRESS_TYPE.HOLD)

func clear_input():
	for action in input_pressed.keys():
		input_pressed[action] = false
		input_hold[action] = false


# Private
func get_action(action_name: String, type: int):
	if type == PRESS_TYPE.HOLD:
		return input_hold[action_name]
	else:
		return input_pressed[action_name]

func set_action(action_name: String, value, type: int):
	if type == PRESS_TYPE.HOLD:
		input_hold[action_name] = value
	else:
		input_pressed[action_name] = value
