extends Node2D

class_name BigBoard

signal tile_pressed(board_id, tile_id)

onready var boards = $Boards


func check_victory() -> bool:
	var game_status = get_game_status()
	var game_result_type = check_winning_player(game_status)
	return game_result_type != Enums.TILE_TYPE.EMPTY


func get_tile_by_id(_board_id : int, _tile_id : int):
	return get_board_by_id(_board_id).get_tile_by_id(_tile_id)

func get_board_by_id(_id : int):
	for small_board in boards.get_children():
		if small_board.id == _id:
			return small_board
	return null

func get_all_playable_boards():
	var available_boards = []
	for board in boards.get_children():
		for tile in board.get_all_empty_tiles():
			if tile.is_available:
				available_boards.append(board)
				break
	return available_boards

func update_tile_modes(_tile_played_id : int):
	var played_on_a_won_board = get_board_by_id(_tile_played_id).type != Enums.TILE_TYPE.EMPTY
	for board in boards.get_children():
		for tile in board.get_all_empty_tiles():
			if not played_on_a_won_board:
				if tile.is_empty() and _tile_played_id == tile.board_id:
					tile.turn_on_off(true)
				else:
					tile.turn_on_off(false)
			else:
				if board.id != _tile_played_id and board.type == Enums.TILE_TYPE.EMPTY:
					if tile.is_empty():
						tile.turn_on_off(true)
					else:
						tile.turn_on_off(false)
				else:
					tile.turn_on_off(false)

# Returns a matrix representation of the types of the tiles of each board
func get_game_status():
	var board_arr = []
	for board in boards.get_children():
		board_arr.append(board.get_game_status())
	return board_arr

# Creates a meta-array of the results of each board (who owns them) and checks if a player has won
static func check_winning_player(game_status):
	var board_arr = []
	for i in game_status.size():
		var board_type = SmallBoard.check_board_owner(game_status[i])
		board_arr.append(board_type)
	
	for pattern in Globals.VICTORY_PATTERNS:
		var a = board_arr[pattern[0] - 1]
		var b = board_arr[pattern[1] - 1]
		var c = board_arr[pattern[2] - 1]
		if a == Enums.TILE_TYPE.EMPTY or b == Enums.TILE_TYPE.EMPTY or c == Enums.TILE_TYPE.EMPTY:
			continue
		if a == b and b == c and a == c:
			return a
	return Enums.TILE_TYPE.EMPTY

func _on_SmallBoard_tile_pressed(board_id, tile_id):
	emit_signal("tile_pressed", board_id, tile_id)
