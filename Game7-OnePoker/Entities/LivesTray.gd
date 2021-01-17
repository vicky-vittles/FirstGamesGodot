extends Node2D

const STATUE_SIZE = Vector2(22, 47)
const MAX_HORIZONTAL_STATUES = 4
const INITIAL_POSITION = Vector2(10, 10)
const PADDING = Vector2(STATUE_SIZE.x, 0) + Vector2(20, 0)
const LINE_BREAK_PADDING = Vector2(0, STATUE_SIZE.y) + Vector2(50, 30)

onready var statues = $Statues
onready var next_pos = $NextPos

var current_line_statue_number = 0


func put_statue(_statue) -> void:
	if current_line_statue_number >= MAX_HORIZONTAL_STATUES:
		current_line_statue_number = 0
		next_pos.global_position = Vector2(
					INITIAL_POSITION.x + LINE_BREAK_PADDING.x,
					next_pos.global_position + LINE_BREAK_PADDING.y)
	current_line_statue_number += 1
	statues.add_child(_statue)
	_statue.go_to_target(next_pos.global_position)
	next_pos.global_position += PADDING
