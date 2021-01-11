extends Node

export (int) var player_index
export (Enums.PLAYER_TYPE) var player_type
export (Enums.TILE_TYPE) var tile_type

var chosen_tile


func init(_index : int, _type):
	player_index = _index
	player_type = _type


func play_turn(game):
	pass
