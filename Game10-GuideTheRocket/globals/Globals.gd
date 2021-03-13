extends Node

const ANTENNA_CURSOR = preload("res://assets/Satellite.png")

onready var display_size = Vector2(
		ProjectSettings.get_setting("display/window/size/width"),
		ProjectSettings.get_setting("display/window/size/height")
		)

func set_cursor_default():
	Input.set_custom_mouse_cursor(null)

func set_cursor_antenna():
	Input.set_custom_mouse_cursor(ANTENNA_CURSOR)
