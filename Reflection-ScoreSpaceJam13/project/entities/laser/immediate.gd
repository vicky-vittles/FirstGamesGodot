extends State

var laser
onready var ACTIVE = $"../Active"

func enter(_info):
	laser = fsm.actor
	laser.raycast.set_laser_color(laser.FADED_COLOR)
	laser.raycast.shoot_at(laser.direction)

func physics_process(delta):
	if fsm.current_state == self:
		fsm.change_state(ACTIVE)
