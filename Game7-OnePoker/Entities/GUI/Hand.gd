extends Node2D

const CARD = preload("res://Entities/Card/Card.tscn")

onready var pos = {1: $Pos1, 2: $Pos2}
var cards_on_hand = {1: null, 2: null}
var next_pos_index : int = 1


# Receive new card and place in empty slot of hand
func receive_card(card) -> void:
	if next_pos_index == 3:
		return
	var _card_to_add = CARD.instance()
	_card_to_add.init(card)
	add_child(_card_to_add)
	var next_pos = pos[next_pos_index]
	_card_to_add.go_to_target(next_pos.global_position)
	cards_on_hand[next_pos_index] = _card_to_add
	
	var other_index = 3 - next_pos_index
	if cards_on_hand[other_index]:
		next_pos_index = 3
	else:
		next_pos_index = other_index
