extends Node

var player_index : int
var player_type
var tile_type
var chosen_tile

func init(_index : int, _type, _tile_type):
	player_index = _index
	player_type = _type
	tile_type = _tile_type

func play_turn(_game):
	pass
