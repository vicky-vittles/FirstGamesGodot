extends Node2D

signal pressed(board_id, cell_id)

onready var cells = $Cells

var id : int

func _ready():
	for cell in cells.get_children():
		cell.id = int(cell.name)

func get_cell_by_coord(x: int, y: int):
	if x >= 0 and x < Globals.BOARD_SIZE and y >= 0 and y < Globals.BOARD_SIZE:
		return cells.get_child(Globals.BOARD_SIZE * (x-1) + y-1)
	return null

func get_cell_by_id(id: int):
	if id > 0 and id <= Globals.BOARD_SIZE*Globals.BOARD_SIZE:
		return cells.get_child(id - 1)

func _on_Cell_pressed(cell_id: int):
	emit_signal("pressed", id, cell_id)
