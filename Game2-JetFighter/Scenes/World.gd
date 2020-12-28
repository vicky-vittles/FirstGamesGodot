extends Node2D

const BOT_GAME = preload("res://Scenes/VsBotGame.tscn")
const PLAYER_GAME = preload("res://Scenes/VsPlayerGame.tscn")

enum GAME_TYPE {VS_PLAYER, VS_BOT}

onready var GAMES = {GAME_TYPE.VS_PLAYER: PLAYER_GAME,
					GAME_TYPE.VS_BOT: BOT_GAME}

onready var main_screens = $MainScreens


func new_game(game_type):
	var game = GAMES[game_type].instance()
	
	main_screens.queue_free()
	
	add_child(game)


func _on_MainScreens_start_vs_player_game():
	new_game(GAME_TYPE.VS_PLAYER)

func _on_MainScreens_start_vs_bot_game():
	new_game(GAME_TYPE.VS_BOT)
