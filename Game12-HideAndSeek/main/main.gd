extends Node

const FGD = preload("res://addons/qodot/game_definitions/fgd/qodot_fgd.tres")

func _ready():
	FGD.set_export_file()

func _process(delta):
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
