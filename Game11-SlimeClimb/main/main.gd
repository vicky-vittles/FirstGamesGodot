extends Node

func _ready():
	TranslationServer.set_locale("en")

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
