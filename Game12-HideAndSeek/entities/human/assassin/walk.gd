extends "res://entities/human/states/walk.gd"

onready var ATTACK = $"../Attack"

func physics_process(delta):
	human.full_movement(delta)
	if human.input.get_press("attack"):
		fsm.change_state(ATTACK)
	elif human.input.get_press("jump"):
		fsm.change_state(JUMP)
	elif human.move_direction == Vector3.ZERO:
		fsm.change_state(IDLE)
