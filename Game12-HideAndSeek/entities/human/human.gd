extends KinematicBody

onready var input = $DeviceController
onready var graphics = $Graphics

func get_input():
	if input:
		input.get_input()
