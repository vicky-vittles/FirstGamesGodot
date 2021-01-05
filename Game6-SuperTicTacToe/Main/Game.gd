extends Node2D

onready var boards = $Boards
onready var players = $Players
var player_turn : int = 1

func _ready():
	for board in boards.get_children():
		board.id = int(board.name)
		
		for cell in board.cells.get_children():
			cell.enable()

func get_board_by_coord(x: int, y: int):
	if x >= 0 and x < Globals.BOARD_SIZE and y >= 0 and y < Globals.BOARD_SIZE:
		return boards.get_child(Globals.BOARD_SIZE * (x-1) + y-1)
	return null

func get_board_by_id(id: int):
	if id > 0 and id <= Globals.BOARD_SIZE*Globals.BOARD_SIZE:
		return boards.get_child(id - 1)


func _on_Cell_pressed(board_id: int, cell_id: int):
	var cell = get_board_by_id(board_id).get_cell_by_id(cell_id)
	cell.value = get_player_by_id(player_turn).own_cell_type
	cell.disable()
	
	change_player_turn()


func change_player_turn():
	player_turn = 3 - player_turn


func get_player_by_id(_id: int):
	for p in players.get_children():
		if p.id == _id:
			return p
	return null
