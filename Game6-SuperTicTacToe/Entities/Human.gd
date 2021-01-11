extends "res://Entities/_Player.gd"

func play_turn(game):
	if game.clicked_tile:
		chosen_tile = game.clicked_tile
