extends State

var laser
onready var ANTICIPATE = $"../Anticipate"

func enter(_info):
	laser = fsm.actor

func _on_Laser_initialized():
	if fsm.current_state == self:
		fsm.change_state(ANTICIPATE)
