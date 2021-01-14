extends Node

const GAME_OVER_SCREEN = preload("res://Screens/NewGameOverScreen.tscn")

onready var main_screens = $MainScreens
onready var final_screen = $FinalScreen
onready var game_builder = $GameBuilder
var game

func _on_MainScreens_start_game(opponent_type_chosen):
	main_screens.queue_free()
	
	var game_objects = game_builder.build_game(opponent_type_chosen)
	game = game_objects["game"]
	var human_player = game_objects["human_player"]
	var opponent_player = game_objects["opponent_player"]
	add_child(game)
	game.players.add_child(human_player)
	game.players.add_child(opponent_player)
	game.init_players()
	
	game.connect("game_ended", self, "_on_Game_game_ended")

func _on_Game_game_ended(_winning_player):
	game.queue_free()
	var game_over_screen = GAME_OVER_SCREEN.instance()
	final_screen.add_child(game_over_screen)
	game_over_screen.set_message(str(Enums.TILE_TYPE.keys()[_winning_player.tile_type]) + " has won!")
