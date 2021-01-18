extends Node

const INVALID_PLAYER_ID = -1

var other_player_id = INVALID_PLAYER_ID


# int(Node.name)
static func sort_by_name_int(a, b):
	if (int(a.name) < int(b.name)):
		return true
	return false


# [ {id:, name:}, {id:,name:} ]
static func sort_by_network_id(a, b):
	if (a["id"] < b["id"]):
		return true
	return false
