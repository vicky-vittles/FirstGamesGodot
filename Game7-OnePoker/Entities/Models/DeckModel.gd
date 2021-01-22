extends Node

class_name DeckModel

const CARD_MODEL_SCENE = preload("res://Entities/Models/CardModel.tscn")

const TOTAL_CARDS_IN_ONE_DECK = 52
const DECKS_USED = 2
const TOTAL_CARDS = TOTAL_CARDS_IN_ONE_DECK * DECKS_USED

onready var cards = $Cards


# Create deck with correct cards, and shuffle them
func init():
	randomize()
	create_decks()
	shuffle()


# Create deck using N normal decks
func create_decks() -> void:
	for _i in range(1, DECKS_USED + 1):
		for suit in Enums.CARD_SUITS.values():
			for value in Enums.CARD_VALUES.values():
				var new_card = CARD_MODEL_SCENE.instance()
				new_card.init(suit, value)
				cards.add_child(new_card)


# Shuffle the cards
func shuffle() -> void:
	var current_index = 0
	var length = cards.get_child_count()
	while current_index < length:
		var indeces_till_end = length - current_index
		var random_index = current_index + randi() % indeces_till_end
		
		var current_card = cards.get_child(current_index)
		var random_card = cards.get_child(random_index)
		
		cards.move_child(current_card, random_index)
		cards.move_child(random_card, current_index)
		
		current_index += 1


# Give the first card of the deck to a player
func buy_card():
	var _card_to_return = cards.get_child(0)
	cards.remove_child(0)
	return _card_to_return
