extends "res://Entities/_Player.gd"

func play_turn(game):
	var available_boards = game.big_board.get_all_playable_boards()
	print(available_boards.size())
