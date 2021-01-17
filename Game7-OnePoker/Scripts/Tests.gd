extends Node

# Default card suit, because suits don't really matter in this game
const def_suit = Enums.CARD_SUITS.CLUBS


func _ready():
	_CardModel_against_card_tests()
	_DeckModel_create_tests()
	_GameModel_tests()
	pass


func _GameModel_tests():
	_GameModel_start_game_test()
	_GameModel_game_test()

func _GameModel_start_game_test():
	var game_model = GameModel.new()
	game_model.init([1, 13371337])
	game_model.start_game()
	for i in game_model.players.size():
		assert(game_model.players[i].hand.size() == 2)

func _GameModel_game_test():
	var game_model = GameModel.new()
	game_model.init([1, 2])
	var card_1 = CardModel.new()
	card_1.init(def_suit, Enums.CARD_VALUES.TWO)
	var card_2 = CardModel.new()
	card_2.init(def_suit, Enums.CARD_VALUES.THREE)
	var card_3 = CardModel.new()
	card_3.init(def_suit, Enums.CARD_VALUES.JACK)
	var card_4 = CardModel.new()
	card_4.init(def_suit, Enums.CARD_VALUES.ACE)
	assert(game_model.last_winning_player_id == -1)
	
	
	game_model.get_player_by_id(1).hand = [card_1, card_4]
	game_model.get_player_by_id(2).hand = [card_2, card_3]
	var _cards_played = {
				1: game_model.get_player_by_id(1).hand[0],
				2: game_model.get_player_by_id(2).hand[0]}
	var _lives_played = {
				1: 3,
				2: 3}
	game_model.play_turn(_cards_played, _lives_played)
	assert(game_model.get_player_by_id(1).lives == 4)
	assert(game_model.get_player_by_id(2).lives == 10)
	assert(game_model.get_player_by_id(1).hand.size() == 2)
	assert(game_model.get_player_by_id(2).hand.size() == 2)
	assert(game_model.get_player_by_id(1).hand[0] == card_4)
	assert(game_model.get_player_by_id(2).hand[0] == card_3)
	assert(game_model.last_winning_player_id == 2)
	
	
	_cards_played = {
				1: game_model.get_player_by_id(1).hand[0],
				2: game_model.get_player_by_id(2).hand[0]}
	_lives_played = {
				1: 1,
				2: 1}
	game_model.play_turn(_cards_played, _lives_played)
	assert(game_model.get_player_by_id(1).lives == 5)
	assert(game_model.get_player_by_id(2).lives == 9)
	assert(game_model.get_player_by_id(1).hand.size() == 2)
	assert(game_model.get_player_by_id(2).hand.size() == 2)
	assert(game_model.last_winning_player_id == 1)
	
	
	var card_5 = CardModel.new()
	card_5.init(def_suit, Enums.CARD_VALUES.SEVEN)
	var card_6 = CardModel.new()
	card_6.init(def_suit, Enums.CARD_VALUES.SEVEN)
	game_model.get_player_by_id(1).hand = [card_5, card_5]
	game_model.get_player_by_id(2).hand = [card_6, card_6]
	_cards_played = {
				1: game_model.get_player_by_id(1).hand[0],
				2: game_model.get_player_by_id(2).hand[0]}
	_lives_played = {
				1: 4,
				2: 4}
	game_model.play_turn(_cards_played, _lives_played)
	assert(game_model.get_player_by_id(1).lives == 5)
	assert(game_model.get_player_by_id(2).lives == 9)
	assert(game_model.get_player_by_id(1).hand.size() == 2)
	assert(game_model.get_player_by_id(2).hand.size() == 2)
	assert(game_model.get_player_by_id(1).hand[0] == card_5)
	assert(game_model.get_player_by_id(2).hand[0] == card_6)
	assert(game_model.last_winning_player_id == 1)


func _DeckModel_create_tests():
	_DeckModel_size_test()
	_DeckModel_correct_suits_test()
	#_DeckModel_print_test()
	_DeckModel_buy_card_test()

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
		assert(total_suits[suit] == DeckModel.TOTAL_CARDS / 4)

func _DeckModel_print_test():
	var deck = DeckModel.new()
	deck.init()
	for i in deck.cards.size():
		print(deck.cards[i])

func _DeckModel_buy_card_test():
	var cards_removed = 5
	var deck = DeckModel.new()
	deck.init()
	for i in cards_removed:
		var _rand_card = deck.buy_card()
	assert(deck.cards.size() == DeckModel.TOTAL_CARDS - cards_removed)


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
