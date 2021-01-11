extends Node2D

signal tile_pressed(board_id, tile_id)

onready var boards = $Boards


func check_victory():
	for pattern in Globals.VICTORY_PATTERNS:
		var a = get_board_by_id(pattern[0]).type
		var b = get_board_by_id(pattern[1]).type
		var c = get_board_by_id(pattern[2]).type
		if a == Enums.TILE_TYPE.EMPTY or b == Enums.TILE_TYPE.EMPTY or c == Enums.TILE_TYPE.EMPTY:
			continue
		if a == b and b == c and a == c:
			return true
	return false


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

func _on_SmallBoard_tile_pressed(board_id, tile_id):
	emit_signal("tile_pressed", board_id, tile_id)
