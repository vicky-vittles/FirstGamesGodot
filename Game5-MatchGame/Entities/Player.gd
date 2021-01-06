extends Node

export (int) var player_index = 0
export (Globals.PLAYER_TYPE) var type = Globals.PLAYER_TYPE.HUMAN

var points : int = 0

func init(_index : int, _type):
	player_index = _index
	type = _type

func play_turn():
	pass
