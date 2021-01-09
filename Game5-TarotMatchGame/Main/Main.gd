extends Node

const GAME_OVER_SCREEN = preload("res://Screens/GameOverScreen.tscn")

onready var game = $Game

func _on_Game_game_ended(players_arr):
	game.queue_free()
	
	players_arr.sort_custom(Globals, "sort_by_points")
	var has_a_winning_player = players_arr[0][1] != players_arr[1][1]
	
	var game_over_screen = GAME_OVER_SCREEN.instance()
	add_child(game_over_screen)
	
	game_over_screen.set_winning_message(has_a_winning_player, players_arr)
