extends Node2D

signal game_ended(points)

onready var board = $Board
onready var player_turn_label = $GUI/PlayerTurnLabel
onready var animation_player = $AnimationPlayer
onready var card_show_timer = $CardShowTimer

export (int) var number_of_pairs = 16
export (int) var number_of_players = 2

var player_turns = []
var cards_selected = []
var cards_to_close = []
var player_points = {}


func init(_pairs : int, _players : int):
	number_of_pairs = _pairs
	number_of_players = _players
	
	for i in range(1, number_of_players + 1):
		player_turns.append(i)
		player_points[i] = 0


func _ready():
	init(number_of_pairs, number_of_players)
	board.generate_new_board()
	board.debug()


func _process(delta):
	while cards_selected.size() < 2:
		return
	
	var equal_cards = check_chosen_cards(cards_selected[0], cards_selected[1])
	var card_1 = board.get_card_by_id(cards_selected[0][0])
	var card_2 = board.get_card_by_id(cards_selected[1][0])
	
	if equal_cards:
		card_1.queue_free()
		card_2.queue_free()
		
		player_points[get_player_turn()] += 1
	else:
		cards_to_close = cards_selected.duplicate(true)
	
	cards_selected.clear()
	
	card_show_timer.start()
	board.disable_all_cards()


func advance_turn() -> void:
	var previous_player = player_turns.pop_front()
	player_turns.push_back(previous_player)
	
	player_turn_label.text = "Player " + str(get_player_turn()) + "'s turn"
	animation_player.play("advance_turn")


func get_player_turn() -> int:
	return player_turns.front()


func check_chosen_cards(c1, c2) -> bool:
	return c1[1] == c2[1] and c1[2] == c2[2]


func _on_Board_card_flipped(id, card_suit, card_value):
	cards_selected.append([id, card_suit, card_value])


func _on_CardShowTimer_timeout():
	if cards_to_close:
		board.get_card_by_id(cards_to_close[0][0]).close()
		board.get_card_by_id(cards_to_close[1][0]).close()
		cards_to_close.clear()
	
	board.enable_all_cards()
	advance_turn()


func _on_Board_game_ended():
	emit_signal("game_ended", player_points)
