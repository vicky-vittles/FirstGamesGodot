extends Node2D

signal tile_pressed(board_id, tile_id)

onready var tiles = $Tiles

onready var id = int(self.name)


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
