extends Node

class_name GameModel

signal player_chose_card(player_id, card_suit, card_value)
signal change_game_stage(new_stage)

const PLAYER_MODEL_SCENE = preload("res://Entities/Models/PlayerModel.tscn")

enum GAME_STAGES {
	BUYING_CARDS = 0,
	CHOOSING_CARDS = 1,
	BETTING_LIVES = 2,
	CARD_RESULT = 3,
	GETTING_LIVES = 4,
	GAME_END = 5 }

var game_stage setget set_game_stage
onready var deck = $DeckModel
onready var players = $Players
var chosen_cards = {}
var last_winning_player_id


# _players : [ {id:1, name:""}, {id:2, name:""} ]
func init(_players):
	var players_to_add = []
	for _player in _players:
		var new_player = PLAYER_MODEL_SCENE.instance()
		new_player.init(_player["id"], _player["name"])
		players_to_add.append(new_player)
	players_to_add.sort_custom(Globals, "sort_by_name_int")
	for i in players_to_add.size():
		$Players.add_child(players_to_add[i])
	deck.init()
	last_winning_player_id = Globals.INVALID_PLAYER_ID
	self.game_stage = GAME_STAGES.BUYING_CARDS


# Starts game
func start_game() -> void:
	for i in 2:
		for j in $Players.get_child_count():
			var _rand_card = deck.buy_card()
			$Players.get_child(j).receive_card(_rand_card)
	self.game_stage = GAME_STAGES.CHOOSING_CARDS


# Returns the player with the given network id
func get_player_by_id(_id : int) -> PlayerModel:
	for i in $Players.get_child_count():
		if $Players.get_child(i).id == _id:
			return $Players.get_child(i)
	return null


# Update chosen card
func player_chose_card(player_id, card_model):
	chosen_cards[player_id] = card_model
	rpc("update_chosen_cards", player_id, card_model.card_suit, card_model.card_value)
	emit_signal("player_chose_card", player_id, card_model)
	if chosen_cards.has(player_id) and chosen_cards.has(Globals.other_player_id):
		if chosen_cards[player_id] and chosen_cards[Globals.other_player_id]:
			self.game_stage = GAME_STAGES.BETTING_LIVES


# Update chosen card of other clients
remote func update_chosen_cards(player_id, card_suit, card_value):
	var card_model = CardModel.new()
	card_model.init(card_suit, card_value)
	chosen_cards[player_id] = card_model
	emit_signal("player_chose_card", player_id, card_model)


# Plays a turns with the given chosen cards
# _chosen_card = {id: card}
func play_turn(_chosen_cards, _lives_bet) -> void:
	var total_lives_to_gain = 0
	for i in $Players.get_child_count():
		var _card_to_play = _chosen_cards[$Players.get_child(i).id]
		$Players.get_child(i).play_card(_card_to_play)
		var _lives_bet_by_player = _lives_bet[$Players.get_child(i).id]
		$Players.get_child(i).bet_lives(_lives_bet_by_player)
		total_lives_to_gain += _lives_bet_by_player
	
	var first_player = $Players.get_child(0)
	var first_player_card = _chosen_cards[first_player.id]
	var last_player = $Players.get_child(1)
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
		var _rand_index = randi() % $Players.get_child_count()
		first_player_id_to_receive_card = $Players.get_child(_rand_index).id
	if $Players.get_child(0).id != first_player_id_to_receive_card:
		$Players.move_child($Players.get_child(0), $Players.get_child_count()-1)
	
	for i in $Players.get_child_count():
		var _card_to_give = deck.buy_card()
		$Players.get_child(i).receive_card(_card_to_give)


# Called when the game stage is updated. Also sends the update to all the other clients
func set_game_stage(new_stage):
	game_stage = new_stage
	rpc("update_game_stage", game_stage)
	emit_signal("change_game_stage", game_stage)


# Called by another client to update the game stage and tell the other clients
remote func update_game_stage(new_stage):
	game_stage = new_stage
	emit_signal("change_game_stage", game_stage)
