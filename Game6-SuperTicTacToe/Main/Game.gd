extends Node2D

signal game_ended(winning_player, players)

onready var status_label = $GUI/StatusLabel
onready var big_board = $BigBoard
onready var players = $Players

var player_turns = []
var clicked_tile
var last_played_tile_id : int


func _ready():
	for i in range(1, players.get_child_count() + 1):
		player_turns.append(i)


func _process(delta):
	process_player_turn()


func process_player_turn():
	var actual_player = get_actual_player()
	actual_player.play_turn(self)
	
	if actual_player.chosen_tile:
		# Get board of played tile
		var chosen_tile_board_id = actual_player.chosen_tile.board_id
		var small_board = big_board.get_board_by_id(chosen_tile_board_id)
		
		# Get played tile
		var chosen_tile_id = actual_player.chosen_tile.id
		var tile = big_board.get_tile_by_id(chosen_tile_board_id, chosen_tile_id)
		
		# Fill tile with player point
		tile.fill_by_player(actual_player.tile_type)
		last_played_tile_id = chosen_tile_id
		
		# Check victories for small board and big board
		var has_conquered_small_board = small_board.check_victory()
		if has_conquered_small_board:
			small_board.set_type(actual_player.tile_type)
		var has_won = big_board.check_victory()
		if has_won:
			emit_signal("game_ended", actual_player, players)
			return
		
		# Update board tiles
		big_board.update_tile_modes(chosen_tile_id)
		
		# Reset clicked tile variables
		clicked_tile = null
		actual_player.chosen_tile = null
		
		# Advance turn
		advance_turn()


func get_player(_index : int):
	for p in players.get_children():
		if p.player_index == _index:
			return p
	return null

func get_actual_player():
	var _index = player_turns.front()
	return get_player(_index)

func advance_turn():
	var player_of_past_turn = player_turns.pop_front()
	player_turns.push_back(player_of_past_turn)
	
	status_label.text = str(Enums.TILE_TYPE.keys()[get_actual_player().tile_type]) + " is playing"

func get_game_status():
	var game_status = big_board.get_game_status()
	var status = {
				"last_played_tile_id": last_played_tile_id,
				"next_player": get_actual_player().tile_type,
				"game_status": game_status}
	return status

func _on_BigBoard_tile_pressed(board_id, tile_id):
	clicked_tile = big_board.get_board_by_id(board_id).get_tile_by_id(tile_id)
