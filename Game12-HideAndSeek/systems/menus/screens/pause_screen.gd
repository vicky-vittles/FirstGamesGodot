extends "res://systems/menus/screens/_BaseScreen.gd"

signal resume()
signal go_to_options_screen()

func _physics_process(delta):
	if get_parent().current_screen == self:
		if Input.is_action_just_pressed("pause"):
			emit_signal("resume")

func enter():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func quit():
	get_tree().quit()
