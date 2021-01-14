extends Node

onready var player_builder = $PlayerBuilder

const GAME_SCENE = preload("res://Main/Game.tscn")

func build_game(opponent_type_chosen):
	var game = GAME_SCENE.instance()
	var human_player = player_builder.build_player(1, Enums.PLAYER_TYPE.HUMAN, Enums.TILE_TYPE.X)
	var opponent_player = player_builder.build_player(2, opponent_type_chosen, Enums.TILE_TYPE.O)
	human_player.name = "1"
	opponent_player.name = "2"
	return {"game":game, "human_player":human_player, "opponent_player":opponent_player}
