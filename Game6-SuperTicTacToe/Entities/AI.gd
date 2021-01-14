extends "res://Entities/_Player.gd"

var GAME_SCORES = {
			Enums.TILE_TYPE.EMPTY: 0,
			Enums.TILE_TYPE.TIE: 0}
var BOARD_SCORES = {
			Enums.TILE_TYPE.EMPTY: 0,
			Enums.TILE_TYPE.TIE: 0}
var TILE_SCORES = {
			Enums.TILE_TYPE.EMPTY: 0,
			Enums.TILE_TYPE.TIE: 0}


func _ready():
	var enemy_tile_type
	if tile_type == Enums.TILE_TYPE.O:
		enemy_tile_type = Enums.TILE_TYPE.X
	elif tile_type == Enums.TILE_TYPE.X:
		enemy_tile_type = Enums.TILE_TYPE.O
	
	GAME_SCORES[tile_type] = 100
	GAME_SCORES[enemy_tile_type] = -100
	BOARD_SCORES[tile_type] = 10
	BOARD_SCORES[enemy_tile_type] = -10
	TILE_SCORES[tile_type] = 1
	TILE_SCORES[enemy_tile_type] = -1


func play_turn(game):
	var game_status = game.get_game_status()
	var minimax_eval = minimax(game_status, null, 2, -INF, INF, true)
	var next_move = minimax_eval["move"]
	chosen_tile = game.big_board.get_board_by_id(next_move[0]).get_tile_by_id(next_move[1])


func minimax(game_status, move_taken, depth : int, alpha, beta, is_maximizing_player : bool):
	var winning_player = BigBoard.check_winning_player(game_status["game_status"])
	var game_is_over = winning_player != Enums.TILE_TYPE.EMPTY
	
	if depth == 0 or game_is_over:
		var score_to_return = evaluate_board(game_status, move_taken, depth, winning_player, is_maximizing_player)
		#print(str(depth) + ": " + str(move_taken) + " " + str(score_to_return))
		return {"move": move_taken, "score":score_to_return}
	
	if is_maximizing_player:
		var max_eval = -INF
		var move_to_take
		var possible_moves = get_all_possible_moves(game_status)
		for possible_move in possible_moves:
			var saved_tile_id = game_status["last_played_tile_id"]
			game_status = apply_move_to_game_status(possible_move, game_status)
			var eval = minimax(game_status, possible_move, depth-1, alpha, beta, false)["score"]
			print(str(depth) + ": " + str(possible_move) + " " + str(eval))
			game_status = undo_move_to_game_status(possible_move, saved_tile_id, game_status)
			if eval > max_eval:
				max_eval = eval
				move_to_take = possible_move
			alpha = max(eval, alpha)
			if beta <= alpha:
				break
		return {"move": move_to_take, "score": max_eval}
	else:
		var min_eval = INF
		var move_to_take
		var possible_moves = get_all_possible_moves(game_status)
		for possible_move in possible_moves:
			var saved_tile_id = game_status["last_played_tile_id"]
			game_status = apply_move_to_game_status(possible_move, game_status)
			var eval = minimax(game_status, possible_move, depth-1, alpha, beta, true)["score"]
			print(str(depth) + ": " + str(possible_move) + " " + str(eval))
			game_status = undo_move_to_game_status(possible_move, saved_tile_id, game_status)
			if eval < min_eval:
				min_eval = eval
				move_to_take = possible_move
			beta = min(eval, beta)
			if beta <= alpha:
				break
		return {"move": move_to_take, "score": min_eval}


func evaluate_board(game_status, move_taken, depth : int, winning_player, is_maximizing_player : bool):
	var lp_tile_id = game_status["last_played_tile_id"]
	var sb_owner_info = SmallBoard.check_small_board_owner(game_status["game_status"], lp_tile_id, game_status["next_player"])
	var sb_rank = BigBoard.rank_small_board(game_status, lp_tile_id)
	#var tile_rank = SmallBoard.rank_tile(game_status, move_taken[0], move_taken[1])
	
	var game_score = GAME_SCORES[winning_player]
	var board_score = BOARD_SCORES[sb_owner_info["owner"]] * sb_owner_info["biggest_score"] * sb_rank
	#var tile_score = TILE_SCORES[tile_rank["player"]] * tile_rank["rank"]
	
	var score_to_return = game_score + board_score #+ tile_score
	#print(score_to_return)
	return score_to_return


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
	has_played_on_owned_board = meta_board[last_played_tile_id] != Enums.TILE_TYPE.EMPTY
	
	if not has_played_on_owned_board:
		for tile_index in big_board_status[last_played_tile_id].size():
			var board_id = last_played_tile_id
			if big_board_status[board_id][tile_index] == Enums.TILE_TYPE.EMPTY:
				possible_moves.append([board_id, tile_index, Globals.POSITION_SCORES[tile_index]])
	else:
		for board_index in big_board_status.size():
			var is_board_owned = SmallBoard.check_board_owner(big_board_status[board_index])
			if is_board_owned:
				continue
			for tile_index in big_board_status[board_index].size():
				if big_board_status[board_index][tile_index] == Enums.TILE_TYPE.EMPTY:
					possible_moves.append([board_index, tile_index, Globals.POSITION_SCORES[tile_index]])
	
	possible_moves.sort_custom(Globals, "sort_by_tile_priority")
	
	return possible_moves


func apply_move_to_game_status(move, game_status):
	game_status["game_status"][move[0]][move[1]] = game_status["next_player"]
	game_status["last_played_tile_id"] = move[1]
	var next_player = game_status["next_player"]
	if next_player == Enums.TILE_TYPE.X:
		game_status["next_player"] = Enums.TILE_TYPE.O
	elif next_player == Enums.TILE_TYPE.O:
		game_status["next_player"] = Enums.TILE_TYPE.X
	
	return game_status


func undo_move_to_game_status(move, last_played_tile_id, game_status):
	var next_player = game_status["next_player"]
	if next_player == Enums.TILE_TYPE.X:
		game_status["next_player"] = Enums.TILE_TYPE.O
	elif next_player == Enums.TILE_TYPE.O:
		game_status["next_player"] = Enums.TILE_TYPE.X
	
	game_status["last_played_tile_id"] = last_played_tile_id
	game_status["game_status"][move[0]][move[1]] = Enums.TILE_TYPE.EMPTY
	
	return game_status


func choose_first_available_tile(game) -> bool:
	var available_boards = game.big_board.get_all_playable_boards()
	for board in available_boards:
		for tile in board.get_all_empty_tiles():
			if tile.is_empty():
				chosen_tile = tile
				return true
	return false
