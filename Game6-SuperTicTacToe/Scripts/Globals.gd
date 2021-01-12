extends Node

const VICTORY_PATTERNS = [
	[0,1,2],
	[3,4,5],
	[6,7,8],
	[0,3,6],
	[1,4,7],
	[2,5,8],
	[0,4,8],
	[2,4,6]]
const POSITION_SCORES = {
	4: 4,
	0: 3,
	2: 3,
	6: 3,
	8: 3,
	1: 2,
	3: 2,
	5: 2,
	7: 2}

# Receives an array: [board_id, tile_id, tile_priority]
static func sort_by_tile_priority(a, b):
	if a[2] > b[2]:
		return true
	return false
