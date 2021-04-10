extends Node

const NUMBER_OF_CHECKPOINTS = 10
const MAX_LAPS = 1

static func sort_by_winner(a, b):
	if a.current_lap > b.current_lap:
		return true
	elif a.current_lap == b.current_lap and a.current_point > b.current_point:
		return true
	return false
