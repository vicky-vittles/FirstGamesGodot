extends Node

const GAME = preload("res://main/game/Game.tscn")

onready var lobby = $Lobby

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

func start_game():
	lobby.queue_free()
	var game = GAME.instance()
	add_child(game)
