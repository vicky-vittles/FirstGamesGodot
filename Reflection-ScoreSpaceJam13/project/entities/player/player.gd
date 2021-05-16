extends KinematicBody2D

signal die()

onready var input_controller = $InputController
onready var character_mover = $CharacterMover

func die():
	emit_signal("die")
