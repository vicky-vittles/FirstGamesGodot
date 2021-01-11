extends "res://Entities/_Player.gd"

const MINIMAX_SCORES = {
			Enums.TILE_TYPE.EMPTY: 0,
			Enums.TILE_TYPE.O: -10,
			Enums.TILE_TYPE.X: 10}


func play_turn(game):
	var game_status = game.get_game_status()
	var minimax_eval = minimax(game_status, null, 1, true)
	var next_move = minimax_eval["move"]
	chosen_tile = game.big_board.get_board_by_id(next_move[0]).get_tile_by_id(next_move[1])


func minimax(game_status, move, depth : int, is_maximizing_player : bool):
	var winning_player = BigBoard.check_winning_player(game_status["game_status"])
	var game_is_over = winning_player != Enums.TILE_TYPE.EMPTY
	
	if depth == 0 or game_is_over:
		return {"move": move, "score":MINIMAX_SCORES[winning_player]}
	
	if is_maximizing_player:
		var max_eval = -INF
		var move_to_take
		var possible_moves = get_all_possible_moves(game_status)
		for move in possible_moves:
			var new_game_status = apply_move_to_game_status(move, game_status)
			var eval = minimax(new_game_status, move, depth-1, false)["score"]
			if eval > max_eval:
				max_eval = eval
				move_to_take = move
		return {"move": move_to_take, "score": max_eval}
	else:
		var min_eval = INF
		var move_to_take
		var possible_moves = get_all_possible_moves(game_status)
		for move in possible_moves:
			var new_game_status = apply_move_to_game_status(move, game_status)
			var eval = minimax(new_game_status, move, depth-1, true)["score"]
			if eval < min_eval:
				min_eval = eval
				move_to_take = move
		return {"move": move_to_take, "score": min_eval}


func get_all_possible_moves(game_status):
	var big_board_status = game_status["game_status"]
	var last_played_tile_id = game_status["last_played_tile_id"]
	
	var possible_moves = []
	var meta_board = []
	
	var has_played_on_owned_board = false
	
	#Create the meta board
	for board_index in big_board_status.size():
		meta_board.append(SmallBoard.check_board_owner(big_board_status[board_index]))
	
	# Check if played on a board owned by someone
	has_played_on_owned_board = meta_board[last_played_tile_id - 1] != Enums.TILE_TYPE.EMPTY
	
	if not has_played_on_owned_board:
		for tile_index in big_board_status[last_played_tile_id - 1].size():
			var board_id = last_played_tile_id
			if big_board_status[board_id-1][tile_index] == Enums.TILE_TYPE.EMPTY:
				possible_moves.append([board_id, (tile_index+1)])
	else:
		for board_index in big_board_status.size():
			var is_board_owned = SmallBoard.check_board_owner(big_board_status[board_index])
			if is_board_owned:
				continue
			for tile_index in big_board_status[board_index].size():
				if big_board_status[board_index][tile_index] == Enums.TILE_TYPE.EMPTY:
					possible_moves.append([(board_index+1), (tile_index+1)])
	
	return possible_moves


func apply_move_to_game_status(move, game_status):
	game_status["game_status"][move[0]-1][move[1]-1] = game_status["next_player"]
	game_status["last_played_tile_id"] = move[1]
	var next_player = game_status["next_player"]
	if next_player == Enums.TILE_TYPE.X:
		game_status["next_player"] = Enums.TILE_TYPE.O
	elif next_player == Enums.TILE_TYPE.O:
		game_status["next_player"] = Enums.TILE_TYPE.X
	
	return game_status


func choose_first_available_tile(game) -> bool:
	var available_boards = game.big_board.get_all_playable_boards()
	for board in available_boards:
		for tile in board.get_all_empty_tiles():
			if tile.is_empty():
				chosen_tile = tile
				return true
	return false
