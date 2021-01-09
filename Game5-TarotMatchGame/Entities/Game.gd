extends Node2D

signal game_ended(players_arr)

enum GAME_STATE { ON_TURN, PAUSED, ON_ANIMATION }

onready var player_turn_label = $GUI/PlayerTurnLabel
onready var board = $Board
onready var memorizing_timer = $MemorizingTimer
onready var animation_player = $AnimationPlayer
onready var player_positions = $PlayerPositions
onready var players = $Players

export (int) var number_of_pairs = 16
export (int) var number_of_players = 2

var game_state = GAME_STATE.ON_TURN
var finished_turn : bool = false
var is_on_memorizing_time : bool = true

var clicked_card
var card_pair_to_check = []
var player_turns = []


func init(_pairs : int, _players : int):
	number_of_pairs = _pairs
	number_of_players = _players
	
	for i in range(1, players.get_child_count() + 1):
		player_turns.append(i)


func _ready():
	init(number_of_pairs, number_of_players)
	board.generate_new_board()


func _process(_delta):
	process_player_turn()
	if board.get_all_closed_cards().size() == 0 and game_state == GAME_STATE.ON_TURN:
		end_game()


func process_player_turn():
	var actual_player = get_player(get_actual_player())
	
	if actual_player.cards_to_turn > 0:
		if game_state == GAME_STATE.ON_TURN:
			finished_turn = false
			actual_player.play_turn(board.get_children())
		
			if actual_player.chosen_card:
				var card = actual_player.chosen_card
				var is_a_closed_card = card.is_openable()
				
				if is_a_closed_card:
					card.open()
					game_state = GAME_STATE.ON_ANIMATION
					card_pair_to_check.append(card)
					actual_player.cards_to_turn += -1
				
				clicked_card = null
				actual_player.chosen_card = null
		
	elif card_pair_to_check.size() == 2:
		if game_state == GAME_STATE.ON_TURN:
			
			var c1 = card_pair_to_check[0]
			var c2 = card_pair_to_check[1]
			
			if c1.card_value == c2.card_value:
				c1.get_captured()
				c2.get_captured()
				actual_player.points += 1
				
				game_state = GAME_STATE.ON_ANIMATION
			else:
				if is_on_memorizing_time and memorizing_timer.is_stopped():
					memorizing_timer.start()
			
				if not is_on_memorizing_time:
					c1.close()
					c2.close()
					card_pair_to_check.clear()


func get_player(_index : int):
	for p in players.get_children():
		if p.name == str(_index):
			return p
	return null


func get_actual_player():
	return player_turns.front()


func advance_turn():
	var player_of_past_turn = player_turns.pop_front()
	get_player(player_of_past_turn).cards_to_turn = 2
	player_turns.push_back(player_of_past_turn)
	player_turn_label.text = "Player " + str(get_actual_player()) + "'s turn"
	animation_player.play("advance_turn")


func _on_Board_choose_card(id, _card_value):
	#if game_state == GAME_STATE.ON_TURN:
	clicked_card = board.get_card_by_id(id)

func _on_Board_animation_ended(id, anim_name):
	game_state = GAME_STATE.ON_TURN
	
	if anim_name == "open":
		for i in player_turns.size():
			var p = get_player(player_turns[i])
			if p.is_an_ai():
				p.put_in_memory(board.get_card_by_id(id))
		
	elif anim_name == "close":
		if not finished_turn:
			advance_turn()
		finished_turn = true
		is_on_memorizing_time = true
		
	elif anim_name == "celebrate":
		if not finished_turn:
			var actual_player = get_player(get_actual_player())
			actual_player.cards_to_turn = 2
			
			var position_to_exit = player_positions.get_child(actual_player.player_index - 1).global_position
			var c1 = card_pair_to_check[0]
			var c2 = card_pair_to_check[1]
			c1.exit_board(position_to_exit)
			c2.exit_board(position_to_exit)
			
			card_pair_to_check.clear()
		finished_turn = true

func end_game():
	var players_arr = []
	for p in players.get_children():
		players_arr.append([p.player_index, p.points])
	emit_signal("game_ended", players_arr)

func _on_MemorizingTimer_timeout():
	game_state = GAME_STATE.ON_TURN
	is_on_memorizing_time = false
