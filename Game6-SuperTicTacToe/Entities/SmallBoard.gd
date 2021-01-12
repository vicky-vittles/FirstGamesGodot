extends Node2D

class_name SmallBoard

signal tile_pressed(board_id, tile_id)

onready var sprite = $Sprite
onready var tiles = $Tiles
onready var id = int(self.name)

var type = Enums.TILE_TYPE.EMPTY


func _ready():
	for tile in tiles.get_children():
		tile.init(id)
		tile.turn_on_off(true)


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
		var a = board_status[pattern[0] - 1]
		var b = board_status[pattern[1] - 1]
		var c = board_status[pattern[2] - 1]
		if a == Enums.TILE_TYPE.EMPTY or b == Enums.TILE_TYPE.EMPTY or c == Enums.TILE_TYPE.EMPTY:
			continue
		if a == b and b == c and a == c:
			return a
	return Enums.TILE_TYPE.EMPTY


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
