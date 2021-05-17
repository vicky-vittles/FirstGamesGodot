extends State

var laser
onready var IMMEDIATE = $"../Immediate"
onready var ANTICIPATE = $"../Anticipate"

func enter(_info):
	laser = fsm.actor

func _on_Laser_initialized():
	if fsm.current_state == self:
		fsm.change_state(ANTICIPATE)

func _on_Laser_immediate_activation():
	if fsm.current_state == self:
		fsm.change_state(IMMEDIATE)
