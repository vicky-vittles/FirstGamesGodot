extends Node

class_name Player

enum PLAYER_TYPE { HUMAN, EASY_AI, NORMAL_AI, PERFECT_AI }
const PLAYER_TYPE_DESC = ["Human", "Easy AI", "Normal AI", "Perfect AI"]

var player_index
var player_type
var game
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
