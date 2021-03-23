extends Node

func _ready():
	TranslationServer.set_locale("pt")
	get_tree().paused = false

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
