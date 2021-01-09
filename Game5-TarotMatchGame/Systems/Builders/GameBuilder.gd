extends Node

const GAME = preload("res://Entities/Game.tscn")
const PLAYER = preload("res://Entities/Player.tscn")
const HUMAN = preload("res://Entities/Human.tscn")
const AI = preload("res://Entities/AI.tscn")

func build_game(opponent_type):
	var opponent_player
	if opponent_type == Player.PLAYER_TYPE.HUMAN:
		opponent_player = HUMAN.instance()
		opponent_player.init(2)
	else:
		opponent_player = AI.instance()
		opponent_player.init(2, opponent_type)
	opponent_player.name = "2"
	
	var game = GAME.instance()
	game.name = "Game"
	game.get_node("Players").add_child(opponent_player)
	opponent_player.game = game
	
	var human_player = game.get_node("Players").get_child(0)
	human_player.init(1)
	human_player.game = game
	
	return game
