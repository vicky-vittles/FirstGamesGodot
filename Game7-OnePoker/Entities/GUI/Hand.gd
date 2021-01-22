extends Node2D

signal card_chosen_from_hand(card)

const CARD = preload("res://Entities/Card/Card.tscn")

onready var pos = {1: $Pos1, 2: $Pos2}
var cards_on_hand = {1: null, 2: null}
var next_pos_index : int = 1


# Receive new card and place in empty slot of hand
func receive_card(card) -> void:
	# If hand full, return
	if next_pos_index == 3:
		return
	
	# Create Card GUI instance, initialize it, and start its animation
	var _card_to_add = CARD.instance()
	_card_to_add.init(card)
	_card_to_add.connect("pressed", self, "card_chosen_from_hand")
	add_child(_card_to_add)
	var next_pos = pos[next_pos_index]
	_card_to_add.go_to_target(next_pos.global_position)
	rpc("show_card", get_path(), _card_to_add.model.card_suit, _card_to_add.model.card_value)
	cards_on_hand[next_pos_index] = _card_to_add
	
	# Calculate next card position
	var other_index = 3 - next_pos_index
	if cards_on_hand[other_index]:
		next_pos_index = 3
	else:
		next_pos_index = other_index


# Open card (using NodePath) so that this player can choose it, but only this player!
master func show_card(_hand_path, card_suit, card_value):
	var hand = get_node(_hand_path)
	var _card_to_show = hand.get_card_by_model(card_suit, card_value)
	_card_to_show.open()


# Listen for card pressed signal in hand
func card_chosen_from_hand(card) -> void:
	emit_signal("card_chosen_from_hand", card)


# Lookup card in hand by suit and value
func get_card_by_model(card_suit, card_value) -> Card:
	for c in get_children():
		if c is Card:
			if c.model.card_suit == card_suit and c.model.card_value == card_value:
				return c
	return null


# Disable all cards
func disable_cards() -> void:
	for c in get_children():
		if c is Card:
			c.disable()

# Enable all cards
func enable_cards() -> void:
	for c in get_children():
		if c is Card:
			c.enable()
