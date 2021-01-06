extends Node2D

class_name Game

signal game_ended(points)

const AI_SCRIPT = preload("res://Scripts/AI.gd")

onready var board = $Board
onready var player_turn_label = $GUI/PlayerTurnLabel
onready var animation_player = $AnimationPlayer
onready var animation_timer = $AnimationTimer
onready var player_point_positions = {1: $PlayerPointPosition1, 2: $PlayerPointPosition2}

export (int) var number_of_pairs = 16
export (int) var number_of_players = 2

var player_turns = []
var cards_selected = []
var cards_to_exit = []
var cards_to_close = []
var player_points = {}
var ais = {}


func init(_pairs : int, _players : int):
	number_of_pairs = _pairs
	number_of_players = _players
	
	for i in range(1, number_of_players + 1):
		player_turns.append(i)
		player_points[i] = 0
	
	ais[1] = [Globals.PLAYER_TYPE.HUMAN, null]
	ais[2] = [Globals.PLAYER_TYPE.EASY_AI, null]
	
	for i in range(1, ais.size() + 1):
		if is_an_ai(i):
			var new_ai = AI_SCRIPT.new()
			new_ai.init(i, ais[i][0])
			
			new_ai.connect("chosen_card", self, "_on_AI_chosen_card")
			ais[i][1] = new_ai


func _ready():
	init(number_of_pairs, number_of_players)
	board.generate_new_board()
	board.debug()


func _process(delta):
	ai_turn()
	
	while cards_selected.size() < 2:
		return
	
	var equal_cards = check_chosen_cards(cards_selected[0], cards_selected[1])
	var card_1 = board.get_card_by_id(cards_selected[0][0])
	var card_2 = board.get_card_by_id(cards_selected[1][0])
	
	if equal_cards:
		card_1.celebrate()
		card_2.celebrate()
		cards_to_exit = cards_selected.duplicate(true)
		player_points[get_player_turn()] += 1
	else:
		cards_to_close = cards_selected.duplicate(true)
	
	cards_selected.clear()
	
	animation_timer.start()
	board.disable_all_cards()


func ai_turn():
	for i in range(1, ais.size()+1):
		if i == get_player_turn():
			if is_an_ai(i):
				ais[i][1].play_turn(board.get_children())


func is_an_ai(player_index) -> bool:
	return ais[player_index][0] != Globals.PLAYER_TYPE.HUMAN


func advance_turn() -> void:
	var previous_player = player_turns.pop_front()
	player_turns.push_back(previous_player)
	
	player_turn_label.text = "Player " + str(get_player_turn()) + "'s turn"
	animation_player.play("advance_turn")


func get_player_turn() -> int:
	return player_turns.front()


func check_chosen_cards(c1, c2) -> bool:
	return c1[1] == c2[1]


func _on_AI_chosen_card(player_index, card_id, card_value):
	if get_player_turn() == player_index:
		board.get_card_by_id(card_id).choose_card()


func _on_Board_card_flipped(id, card_value):
	cards_selected.append([id, card_value])
	for i in range(1, ais.size()+1):
		if is_an_ai(i):
			ais[i][1].put_in_memory([id, card_value])


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
		advance_turn()
	
	board.enable_all_cards()


func _on_Board_game_ended():
	emit_signal("game_ended", player_points)
