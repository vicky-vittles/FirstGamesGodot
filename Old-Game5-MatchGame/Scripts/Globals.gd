extends Node

enum PLAYER_TYPE { HUMAN, EASY_AI, NORMAL_AI, PERFECT_AI }

static func sort_by_card_value(a, b):
	if a[1] < b[1]:
		return true
	return false

static func sort_by_points(a, b):
	if a[1] > b[1]:
		return true
	return false
