extends Node

class_name Player

enum PLAYER_TYPE { HUMAN, EASY_AI, NORMAL_AI, PERFECT_AI }

export (NodePath) var game_path
export (int) var player_index = 0
export (PLAYER_TYPE) var player_type

onready var game = get_node(game_path)
var chosen_card

var points : int = 0
var cards_to_turn : int = 2


func init_player(_index : int, _type):
	player_index = _index
	player_type = _type


func play_turn(_cards):
	pass


func is_an_ai() -> bool:
	return player_type != PLAYER_TYPE.HUMAN
