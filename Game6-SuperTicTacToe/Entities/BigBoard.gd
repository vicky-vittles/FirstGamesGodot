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

# Creates a meta-array of the results of each board (who owns them)
# and returns the player who "owns" the big board
static func check_winning_player(game_status):
	var board_arr = []
	for i in game_status.size():
		var board_type = SmallBoard.check_board_owner(game_status[i])
		board_arr.append(board_type)
	
	for pattern in Globals.VICTORY_PATTERNS:
		var a = board_arr[pattern[0]]
		var b = board_arr[pattern[1]]
		var c = board_arr[pattern[2]]
		if a == Enums.TILE_TYPE.EMPTY or b == Enums.TILE_TYPE.EMPTY or c == Enums.TILE_TYPE.EMPTY:
			continue
		if a == b and b == c:
			return a
	return Enums.TILE_TYPE.EMPTY

# Creates a meta-array of the results of each board (using the full board),
# and returns a number indicating how many configurations using the board_to_check_id
# can win the game
static func check_small_board_estimate_value(board_id_to_check : int, player_type, game_status):
	var game_status_temp = []
	for i in game_status.size():
		var board_temp = []
		for j in game_status[i].size():
			var tile_temp = game_status[i][j]
			if tile_temp == Enums.TILE_TYPE.EMPTY:
				tile_temp = player_type
			board_temp.append(tile_temp)
		game_status_temp.append(board_temp)
	
	var meta_board = []
	for i in game_status_temp.size():
		var board_type = SmallBoard.check_board_owner(game_status_temp[i])
		meta_board.append(board_type)
	
	var result = 0
	for pattern in Globals.VICTORY_PATTERNS:
		var a = meta_board[pattern[0]]
		var b = meta_board[pattern[1]]
		var c = meta_board[pattern[2]]
		if a == Enums.TILE_TYPE.EMPTY or b == Enums.TILE_TYPE.EMPTY or c == Enums.TILE_TYPE.EMPTY:
			continue
		if a == b and b == c:
			if pattern[0] == board_id_to_check or pattern[1] == board_id_to_check or pattern[2] == board_id_to_check:
				result += 1
	return result

func _on_SmallBoard_tile_pressed(board_id : int, tile_id : int):
	emit_signal("tile_pressed", board_id, tile_id)
