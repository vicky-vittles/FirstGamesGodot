extends KinematicBody2D

signal path_add_point(point)
signal path_clear_points()

onready var input_controller = $InputController
onready var character_mover = $CharacterMover

func add_point(point):
	emit_signal("path_add_point", point)
