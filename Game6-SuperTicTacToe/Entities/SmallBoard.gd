extends Node2D

class_name SmallBoard

signal tile_pressed(board_id, tile_id)

const STARTING_TILE_TYPE = Enums.TILE_TYPE.X
const SMALL_BOARD_OWNERSHIP = {0: 0, 1:0.5, 2:0.75, 3:1}

onready var sprite = $Sprite
onready var tiles = $Tiles
onready var id = int(self.name)

var type = Enums.TILE_TYPE.EMPTY


func _ready():
	for tile in tiles.get_children():
		tile.init(id)
		tile.turn_on_off(true, STARTING_TILE_TYPE)


# Uses the board status to determine if a player owns this board
func check_victory() -> bool:
	var board_status = get_game_status()
	var board_owner = check_board_owner(board_status)
	
	if board_owner != Enums.TILE_TYPE.EMPTY:
		return true
	else:
		return false

# Returns the general type of this board
# (if its owned by a player - still can be played on)
static func check_board_owner(board_status):
	for pattern in Globals.VICTORY_PATTERNS:
		var a = board_status[pattern[0]]
		var b = board_status[pattern[1]]
		var c = board_status[pattern[2]]
		if a == Enums.TILE_TYPE.EMPTY or b == Enums.TILE_TYPE.EMPTY or c == Enums.TILE_TYPE.EMPTY:
			continue
		if a == b and b == c and a == c:
			return a
	return Enums.TILE_TYPE.EMPTY

# Returns the general type of this board
static func check_supposed_board_owner(board_status):
	for pattern in Globals.VICTORY_PATTERNS:
		var a = board_status[pattern[0]]
		var b = board_status[pattern[1]]
		var c = board_status[pattern[2]]
		var x_count = 1 if a == Enums.TILE_TYPE.X else 0
		x_count = x_count+1 if b == Enums.TILE_TYPE.X else x_count
		x_count = x_count+1 if c == Enums.TILE_TYPE.X else x_count
		var o_count = 1 if a == Enums.TILE_TYPE.O else 0
		o_count = x_count+1 if b == Enums.TILE_TYPE.O else o_count
		o_count = x_count+1 if c == Enums.TILE_TYPE.O else o_count
		if x_count == 0 and o_count == 0:
			continue
		if sign(x_count) > 0 and o_count == 0:
			return Enums.TILE_TYPE.X
		if sign(o_count) > 0 and x_count == 0:
			return Enums.TILE_TYPE.O
	return Enums.TILE_TYPE.EMPTY

static func check_small_board_owner(board_status, board_id, player_type):
	var enemy_type
	if player_type == Enums.TILE_TYPE.X:
		enemy_type = Enums.TILE_TYPE.O
	elif player_type == Enums.TILE_TYPE.O:
		enemy_type = Enums.TILE_TYPE.X
	var result = {"biggest_score": 0, "owner":Enums.TILE_TYPE.EMPTY}
	for pattern in Globals.VICTORY_PATTERNS:
		var a = board_status[board_id][pattern[0]]
		var b = board_status[board_id][pattern[1]]
		var c = board_status[board_id][pattern[2]]
		var ai_count = 1 if a == player_type else 0
		ai_count = ai_count+1 if b == player_type else ai_count
		ai_count = ai_count+1 if c == player_type else ai_count
		var e_count = 1 if a == enemy_type else 0
		e_count = e_count+1 if b == enemy_type else e_count
		e_count = e_count+1 if c == enemy_type else e_count
		if ai_count == 3:
			result["biggest_score"] = 1
			result["owner"] = player_type
			return result
		elif e_count == 3:
			result["biggest_score"] = 1
			result["owner"] = enemy_type
			return result
		elif ai_count > e_count and SMALL_BOARD_OWNERSHIP[ai_count] > result["biggest_score"]:
			result["biggest_score"] = SMALL_BOARD_OWNERSHIP[ai_count]
			result["owner"] = player_type
		elif e_count > ai_count and SMALL_BOARD_OWNERSHIP[e_count] > result["biggest_score"]:
			result["biggest_score"] = SMALL_BOARD_OWNERSHIP[e_count]
			result["owner"] = enemy_type
	return result

static func rank_tile(game_status, board_id, tile_id):
	var player_type
	var next_player = game_status["next_player"]
	if next_player == Enums.TILE_TYPE.X:
		player_type = Enums.TILE_TYPE.O
	elif next_player == Enums.TILE_TYPE.O:
		player_type = Enums.TILE_TYPE.X
	
	var board_temp = []
	for i in game_status["game_status"][board_id].size():
		var tile_temp = game_status["game_status"][board_id][i]
		if tile_temp == Enums.TILE_TYPE.EMPTY:
			tile_temp = player_type
		board_temp.append(tile_temp)
	
	var result = {"rank":0, "player":player_type}
	for pattern in Globals.VICTORY_PATTERNS:
		var a = board_temp[pattern[0]]
		var b = board_temp[pattern[1]]
		var c = board_temp[pattern[2]]
		if a == Enums.TILE_TYPE.EMPTY or b == Enums.TILE_TYPE.EMPTY or c == Enums.TILE_TYPE.EMPTY:
			continue
		if player_type == a and a == b and b == c:
			if pattern[0] == tile_id or pattern[1] == tile_id or pattern[2] == tile_id:
				result["rank"] += 1
	return result


func set_type(_type):
	type = _type
	sprite.texture = Tile.TILE_IMAGES[type]

func get_tile_by_id(_id : int):
	for tile in tiles.get_children():
		if tile.id == _id:
			return tile
	return null

func get_all_tiles():
	return tiles.get_children()

func get_all_empty_tiles():
	var tiles_to_return = []
	for tile in tiles.get_children():
		if tile.is_empty():
			tiles_to_return.append(tile)
	return tiles_to_return

# Returns a array representation of the types of each tile of this board
# [EMPTY, X, O, O, EMPTY, EMPTY, X, EMPTY, EMPTY, O]
func get_game_status():
	var tile_arr = []
	for tile in tiles.get_children():
		tile_arr.append(tile.tile_type)
	return tile_arr

func _on_Tile_tile_pressed(tile_id):
	emit_signal("tile_pressed", id, tile_id)
