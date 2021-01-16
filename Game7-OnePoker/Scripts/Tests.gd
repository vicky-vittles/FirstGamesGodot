extends Node

# Default card suit, because suits don't really matter in this game
const def_suit = Enums.CARD_SUITS.CLUBS


func _ready():
	#_CardModel_against_card_tests()
	#_DeckModel_create_tests()
	pass


func _DeckModel_create_tests():
	_DeckModel_size_test()
	_DeckModel_correct_suits_test()
	_DeckModel_print_test()

func _DeckModel_size_test():
	var deck = DeckModel.new()
	deck.init()
	assert(deck.cards.size() == DeckModel.TOTAL_CARDS_IN_ONE_DECK * DeckModel.DECKS_USED)

func _DeckModel_correct_suits_test():
	var deck = DeckModel.new()
	deck.init()
	var total_suits = []
	for suit in Enums.CARD_SUITS.values():
		total_suits.append(0)
	for i in deck.cards.size():
		total_suits[deck.cards[i].card_suit] += 1
	for suit in Enums.CARD_SUITS.values():
		assert(total_suits[suit] == DeckModel.TOTAL_CARDS_IN_ONE_DECK * DeckModel.DECKS_USED / 4)

func _DeckModel_print_test():
	var deck = DeckModel.new()
	deck.init()
	for i in deck.cards.size():
		print(deck.cards[i])


func _CardModel_against_card_tests():
	_against_card_test_1()
	_against_card_test_2()
	_against_card_test_3()
	_against_card_test_4()
	_against_card_test_5()
	_against_card_test_6()
	_against_card_test_7()

func _against_card_test_1():
	var card_1 = CardModel.new()
	var card_2 = CardModel.new()
	card_1.init(def_suit, Enums.CARD_VALUES.THREE)
	card_2.init(def_suit, Enums.CARD_VALUES.TWO)
	assert(card_1.against_card(card_2) == 1)

func _against_card_test_2():
	var card_1 = CardModel.new()
	var card_2 = CardModel.new()
	card_1.init(def_suit, Enums.CARD_VALUES.FOUR)
	card_2.init(def_suit, Enums.CARD_VALUES.THREE)
	assert(card_1.against_card(card_2) == 1)

func _against_card_test_3():
	var card_1 = CardModel.new()
	var card_2 = CardModel.new()
	card_1.init(def_suit, Enums.CARD_VALUES.ACE)
	card_2.init(def_suit, Enums.CARD_VALUES.KING)
	assert(card_1.against_card(card_2) == 1)

func _against_card_test_4():
	var card_1 = CardModel.new()
	var card_2 = CardModel.new()
	card_1.init(def_suit, Enums.CARD_VALUES.ACE)
	card_2.init(def_suit, Enums.CARD_VALUES.TWO)
	assert(card_1.against_card(card_2) == -1)

func _against_card_test_5():
	var card_1 = CardModel.new()
	var card_2 = CardModel.new()
	card_1.init(def_suit, Enums.CARD_VALUES.TWO)
	card_2.init(def_suit, Enums.CARD_VALUES.TWO)
	assert(card_1.against_card(card_2) == 0)

func _against_card_test_6():
	var card_1 = CardModel.new()
	var card_2 = CardModel.new()
	card_1.init(def_suit, Enums.CARD_VALUES.ACE)
	card_2.init(def_suit, Enums.CARD_VALUES.ACE)
	assert(card_1.against_card(card_2) == 0)

func _against_card_test_7():
	var card_1 = CardModel.new()
	var card_2 = CardModel.new()
	card_1.init(def_suit, Enums.CARD_VALUES.NINE)
	card_2.init(def_suit, Enums.CARD_VALUES.NINE)
	assert(card_1.against_card(card_2) == 0)
