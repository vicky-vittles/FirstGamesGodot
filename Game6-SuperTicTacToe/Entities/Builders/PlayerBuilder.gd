extends Node

const PLAYER_SCENES = {
			Enums.PLAYER_TYPE.HUMAN: preload("res://Entities/Human.tscn"),
			Enums.PLAYER_TYPE.AI: preload("res://Entities/AI.tscn")}

func build_player(player_index : int, player_type, tile_type):
	var player = PLAYER_SCENES[player_type].instance()
	player.init(player_index, player_type, tile_type)
	return player
