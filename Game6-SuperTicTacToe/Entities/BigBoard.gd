extends Node2D

signal tile_pressed(board_id, tile_id)

onready var boards = $Boards


func _on_SmallBoard_tile_pressed(board_id, tile_id):
	emit_signal("tile_pressed", board_id, tile_id)
