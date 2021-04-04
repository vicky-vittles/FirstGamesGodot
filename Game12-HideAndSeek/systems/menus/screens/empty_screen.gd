extends "res://systems/menus/screens/_BaseScreen.gd"

signal paused()

func _physics_process(delta):
	if get_parent().current_screen == self:
		if Input.is_action_just_pressed("pause"):
			emit_signal("paused")

func enter():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
