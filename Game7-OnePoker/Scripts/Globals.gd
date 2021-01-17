extends Node

const INVALID_PLAYER_ID = -1

var other_player_id = INVALID_PLAYER_ID

static func sort_by_name_int(a, b):
	if (int(a.name) < int(b.name)):
		return true
	return false
