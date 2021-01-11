extends Node2D

signal tile_pressed(board_id, tile_id)

onready var sprite = $Sprite
onready var tiles = $Tiles
onready var id = int(self.name)

var type = Enums.TILE_TYPE.EMPTY


func _ready():
	for tile in tiles.get_children():
		tile.init(id)
		tile.turn_on_off(true)


func check_victory() -> bool:
	for pattern in Globals.VICTORY_PATTERNS:
		var a = get_tile_by_id(pattern[0]).tile_type
		var b = get_tile_by_id(pattern[1]).tile_type
		var c = get_tile_by_id(pattern[2]).tile_type
		if a == Enums.TILE_TYPE.EMPTY or b == Enums.TILE_TYPE.EMPTY or c == Enums.TILE_TYPE.EMPTY:
			continue
		if a == b and b == c and a == c:
			return true
	return false


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

func _on_Tile_tile_pressed(tile_id):
	emit_signal("tile_pressed", id, tile_id)
