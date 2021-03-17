extends State

onready var IDLE = $"../Idle"
var slime

func enter():
	slime = fsm.actor

func physics_process(delta):
	slime.move(delta)
	slime.turn_around(slime.direction)

func _on_Slime_on_floor():
	if fsm.current_state == self:
		fsm.change_state(IDLE)
