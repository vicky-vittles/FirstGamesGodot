extends Node

class_name GameModel

var deck : DeckModel
var players
var last_winning_player_id


# _players : [ {id:1, name:""}, {id:2, name:""} ]
func init(_players):
	players = []
	for _player in _players:
		var new_player = PlayerModel.new()
		new_player.init(_player["id"], _player["name"])
		players.append(new_player)
	players.sort_custom(Globals, "sort_by_name_int")
	deck = DeckModel.new()
	deck.init()
	last_winning_player_id = Globals.INVALID_PLAYER_ID


# Starts game
func start_game() -> void:
	for i in 2:
		for j in players.size():
			var _rand_card = deck.buy_card()
			players[j].receive_card(_rand_card)


# Returns the player with the given network id
func get_player_by_id(_id : int) -> PlayerModel:
	for i in players.size():
		if players[i].id == _id:
			return players[i]
	return null


# Plays a turns with the given chosen cards
# _chosen_card = {id: card}
func play_turn(_chosen_cards, _lives_bet) -> void:
	var total_lives_to_gain = 0
	for i in players.size():
		var _card_to_play = _chosen_cards[players[i].id]
		players[i].play_card(_card_to_play)
		var _lives_bet_by_player = _lives_bet[players[i].id]
		players[i].bet_lives(_lives_bet_by_player)
		total_lives_to_gain += _lives_bet_by_player
	
	var first_player = players.front()
	var first_player_card = _chosen_cards[first_player.id]
	var last_player = players.back()
	var last_player_card = _chosen_cards[last_player.id]
	var result_from_match = first_player_card.against_card(last_player_card)
	
	var winning_player
	if result_from_match == 1:
		winning_player = first_player
	elif result_from_match == -1:
		winning_player = last_player
	elif result_from_match == 0:
		winning_player = null
	if winning_player:
		winning_player.gain_lives(total_lives_to_gain)
		last_winning_player_id = winning_player.id
	else:
		first_player.gain_lives(_lives_bet[first_player.id])
		last_player.gain_lives(_lives_bet[last_player.id])
	var first_player_id_to_receive_card = last_winning_player_id
	if first_player_id_to_receive_card == Globals.INVALID_PLAYER_ID:
		var _rand_index = randi() % players.size()
		first_player_id_to_receive_card = players[_rand_index].id
	if players.front().id != first_player_id_to_receive_card:
		players.append(players.pop_front())
	
	for i in players.size():
		var _card_to_give = deck.buy_card()
		players[i].receive_card(_card_to_give)
