extends Node

const GAME_OVER_SCREEN = preload("res://Screens/GameOberScreen.tscn")

onready var game_builder = $GameBuilder
onready var main_screens = $MainScreens


func _on_Game_game_ended(players_arr):
	var game = $Game
	game.queue_free()
	
	players_arr.sort_custom(Globals, "sort_by_points")
	var has_a_winning_player = players_arr[0][1] != players_arr[1][1]
	
	var game_over_screen = GAME_OVER_SCREEN.instance()
	add_child(game_over_screen)
	
	game_over_screen.set_winning_message(has_a_winning_player, players_arr)


func _on_MainScreens_new_game(opponent_type):
	main_screens.queue_free()
	var new_game = game_builder.build_game(opponent_type)
	add_child(new_game)
	new_game.connect("game_ended", self, "_on_Game_game_ended")
