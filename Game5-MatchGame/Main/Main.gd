extends Node

const GAME_OVER_SCREEN = preload("res://Screens/GameOverScreen.tscn")

onready var game = $Game

func _on_Game_game_ended(player_points):
	game.queue_free()
	
	var player_points_arr = []
	for i in range(1, player_points.size() + 1):
		player_points_arr.append([i, player_points[i]])
	
	player_points_arr.sort_custom(Globals, "sort_by_points")
	var has_a_winning_player = player_points_arr[0][1] != player_points_arr[1][1]
	
	var game_over_screen = GAME_OVER_SCREEN.instance()
	add_child(game_over_screen)
	
	game_over_screen.set_winning_message(has_a_winning_player, player_points_arr)
