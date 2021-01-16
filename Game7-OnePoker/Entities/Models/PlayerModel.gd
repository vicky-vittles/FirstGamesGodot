extends Node

class_name PlayerModel

const HAND_SIZE = 2

var id : int
var lives : int
var hand = []


# Constructor
func init(_id : int):
	id = _id
	lives = Settings.INITIAL_LIVES
	hand = []


# Receive new card and put it in hand
func receive_card(_new_card) -> void:
	if hand.size() >= HAND_SIZE:
		return
	hand.append(_new_card)


# Play card and remove it from hand
func play_card(_card) -> void:
	hand.remove(hand.find(_card))


# Returns if its possible to bet this many lives
func bet_lives(_lives_to_bet : int) -> bool:
	if lives >= _lives_to_bet:
		lives = lives - _lives_to_bet
		return true
	return false
