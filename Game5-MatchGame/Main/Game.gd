extends Node2D

class_name Game

signal game_ended(points)

onready var board = $Board
onready var player_point_positions = {1: $PlayerPointPosition1, 2: $PlayerPointPosition2}
onready var player_turn_label = $GUI/PlayerTurnLabel
onready var players = $Players
onready var animation_player = $AnimationPlayer
onready var animation_timer = $AnimationTimer

export (int) var number_of_pairs = 16
export (int) var number_of_players = 2

var player_turns = []
var cards_selected = []
var cards_to_exit = []
var cards_to_close = []


func init(_pairs : int, _players : int):
	number_of_pairs = _pairs
	number_of_players = _players
	
	for i in range(1, number_of_players + 1):
		player_turns.append(i)


func _ready():
	init(number_of_pairs, number_of_players)
	board.generate_new_board()
	#board.debug()


func _process(delta):
	
	if cards_selected.size() < 2:
		ai_turn()
		return
	
	var equal_cards = check_chosen_cards(cards_selected[0], cards_selected[1])
	var card_1 = board.get_card_by_id(cards_selected[0][0])
	var card_2 = board.get_card_by_id(cards_selected[1][0])
	
	if equal_cards:
		card_1.celebrate()
		card_2.celebrate()
		cards_to_exit = cards_selected.duplicate(true)
		get_player(get_player_turn()).points += 1
	else:
		cards_to_close = cards_selected.duplicate(true)
		advance_turn()
	
	cards_selected.clear()
	
	animation_timer.start()
	board.disable_all_cards()


func get_player(_player_index : int):
	for p in players.get_children():
		if p.name == str(_player_index):
			return p
	return null


func ai_turn():
	if is_an_ai(get_player_turn()):
		get_player(get_player_turn()).play_turn()


func is_an_ai(_player_index) -> bool:
	return get_player(_player_index).type != Globals.PLAYER_TYPE.HUMAN


func advance_turn() -> void:
	var previous_player = player_turns.pop_front()
	player_turns.push_back(previous_player)


func update_turn_label() -> void:
	player_turn_label.text = "Player " + str(get_player_turn()) + "'s turn"
	animation_player.play("update_turn_label")


func get_player_turn() -> int:
	return player_turns.front()


func check_chosen_cards(c1, c2) -> bool:
	return c1[1] == c2[1]


func _on_AI_chosen_card(player_index, card_id, card_value):
	if get_player_turn() == player_index:
		board.get_card_by_id(card_id).choose_card()


func _on_Board_card_flipped(id, card_value):
	cards_selected.append([id, card_value])
	for p in players.get_children():
		if is_an_ai(p.player_index):
			p.put_in_memory([id, card_value])


func _on_CardShowTimer_timeout():
	if cards_to_exit:
		var position_to_exit = player_point_positions[get_player_turn()].global_position
		board.get_card_by_id(cards_to_exit[0][0]).exit_board(position_to_exit)
		board.get_card_by_id(cards_to_exit[1][0]).exit_board(position_to_exit)
		cards_to_exit.clear()
	
	if cards_to_close:
		board.get_card_by_id(cards_to_close[0][0]).close()
		board.get_card_by_id(cards_to_close[1][0]).close()
		cards_to_close.clear()
		update_turn_label()
	
	board.enable_all_cards()


func _on_Board_game_ended():
	emit_signal("game_ended", players.get_children)
