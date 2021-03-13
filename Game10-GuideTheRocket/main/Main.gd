extends Node

onready var game = $Game

func _ready():
	get_tree().paused = true
	Globals.set_cursor_antenna()

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func _on_TitleScreen_start_game():
	get_tree().paused = false
