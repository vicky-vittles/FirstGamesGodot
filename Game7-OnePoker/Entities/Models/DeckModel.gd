extends Node

class_name DeckModel

const TOTAL_CARDS_IN_ONE_DECK = 52
const DECKS_USED = 2
const TOTAL_CARDS = TOTAL_CARDS_IN_ONE_DECK * DECKS_USED

var cards = []


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
				var new_card = CardModel.new()
				new_card.init(suit, value)
				cards.append(new_card)


# Shuffle the cards
func shuffle() -> void:
	var current_index = 0
	var length = cards.size()
	while current_index < length:
		var indeces_till_end = length - current_index
		var random_index = current_index + randi() % indeces_till_end
		
		var temp = cards[current_index]
		cards[current_index] = cards[random_index]
		cards[random_index] = temp
		
		current_index += 1


# Give the first card of the deck to a player
func buy_card():
	return cards.pop_front()
