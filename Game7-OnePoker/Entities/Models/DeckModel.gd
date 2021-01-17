extends Node

class_name DeckModel

const TOTAL_CARDS_IN_ONE_DECK = 52
const DECKS_USED = 2
const TOTAL_CARDS = TOTAL_CARDS_IN_ONE_DECK * DECKS_USED

var cards = []


func init():
	randomize()
	create_decks()
	shuffle()


func create_decks() -> void:
	for i in range(1, DECKS_USED + 1):
		for suit in Enums.CARD_SUITS.values():
			for value in Enums.CARD_VALUES.values():
				var new_card = CardModel.new()
				new_card.init(suit, value)
				cards.append(new_card)


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


func buy_card():
	return cards.pop_front()
