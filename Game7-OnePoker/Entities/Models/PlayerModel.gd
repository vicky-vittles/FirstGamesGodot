extends Node

class_name PlayerModel

signal received_card(card)

const HAND_SIZE = 2

var id : int
var player_name : String
var lives : int
var hand = []


# Constructor
func init(_id : int, _player_name : String):
	id = _id
	player_name = _player_name
	lives = Settings.INITIAL_LIVES
	hand = []


# Receive new card and put it in hand
func receive_card(_new_card) -> void:
	if hand.size() >= HAND_SIZE:
		return
	hand.append(_new_card)
	emit_signal("received_card", _new_card)


# Play card and remove it from hand
func play_card(_card) -> void:
	hand.remove(hand.find(_card))


# Returns if its possible to bet this many lives
func bet_lives(_lives_to_bet : int) -> bool:
	if lives >= _lives_to_bet:
		lives = lives - _lives_to_bet
		return true
	return false


# Gain lives that were bet
func gain_lives(_lives_gain : int) -> void:
	lives += _lives_gain
