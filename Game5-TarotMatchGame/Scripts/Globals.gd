extends Node

var debug_mode : bool = false

static func sort_by_card_value(a, b):
	if a.card_value < b.card_value:
		return true
	return false

static func sort_by_points(a, b):
	if a[1] > b[1]:
		return true
	return false
