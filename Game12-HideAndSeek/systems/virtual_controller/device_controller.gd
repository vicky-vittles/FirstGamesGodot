extends VirtualController

class_name DeviceController, "res://assets/icons/device-controller.svg"

onready var all_actions = InputMap.get_actions()

func get_input():
	for action in all_actions:
		var is_pressed = Input.is_action_just_pressed(action)
		var is_hold = Input.is_action_pressed(action)
		set_press(action, is_pressed)
		set_hold(action, is_hold)
