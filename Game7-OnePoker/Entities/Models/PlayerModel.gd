extends Node

class_name PlayerModel

const CARD_MODEL_SCENE = preload("res://Entities/Models/CardModel.tscn")

signal received_card(card)
signal gain_lives(lives)

const HAND_SIZE = 2

var id : int
var player_name : String
var lives : int
onready var hand = $Hand


# Constructor (network id and name)
func init(_id : int, _player_name : String):
	id = _id
	player_name = _player_name
	lives = Settings.INITIAL_LIVES


# Emits signals for the current set variables
func sync_signals() -> void:
	for i in hand.get_child_count():
		var card_in_hand = hand.get_child(i)
		emit_signal("received_card", card_in_hand)


# Receive new card and put it in hand
func receive_card(_new_card) -> void:
	if hand.get_child_count() >= HAND_SIZE:
		return
	var _card_to_add = CARD_MODEL_SCENE.instance()
	_card_to_add.init(_new_card.card_suit, _new_card.card_value)
	hand.add_child(_card_to_add)
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
	emit_signal("gain_lives", _lives_gain)
