extends Node

func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().reload_current_scene()
