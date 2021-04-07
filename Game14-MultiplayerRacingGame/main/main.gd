extends Node

const GAME = preload("res://main/game/Game.tscn")

onready var lobby = $Lobby

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()

func _on_Lobby_start_game():
	remove_child(lobby)
	lobby.queue_free()
	var new_game = GAME.instance()
	add_child(new_game)
