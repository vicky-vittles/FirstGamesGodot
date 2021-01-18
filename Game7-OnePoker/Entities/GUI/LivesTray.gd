extends Node2D

const LIFE_STATUE = preload("res://Entities/GUI/LifeStatue.tscn")

const STATUE_SIZE = Vector2(44, 94)
const MAX_HORIZONTAL_STATUES = 4
const INITIAL_POSITION = Vector2(10, 10)
const PADDING = Vector2(STATUE_SIZE.x, 0) + Vector2(20, 0)
const LINE_BREAK_PADDING = Vector2(0, STATUE_SIZE.y) + Vector2(0, 5)

onready var statues = $Statues
onready var next_pos = $NextPos
onready var label = $Label

var current_line_statue_number = 0


# Initializes GUI with number of starting lives
func init(_lives) -> void:
	for i in _lives:
		var new_statue = LIFE_STATUE.instance()
		put_statue(new_statue)


# Updates the label with the player's name
func change_name(_name) -> void:
	label.text = _name + "'s lives"


# Puts a statue in the tray by calculating its next position inside it
func put_statue(_statue) -> void:
	if current_line_statue_number >= MAX_HORIZONTAL_STATUES:
		current_line_statue_number = 0
		next_pos.global_position = Vector2(
					INITIAL_POSITION.x + LINE_BREAK_PADDING.x,
					next_pos.global_position.y + LINE_BREAK_PADDING.y)
	current_line_statue_number += 1
	statues.add_child(_statue)
	_statue.go_to_target(next_pos.global_position)
	next_pos.global_position += PADDING
	#print(next_pos.global_position)
