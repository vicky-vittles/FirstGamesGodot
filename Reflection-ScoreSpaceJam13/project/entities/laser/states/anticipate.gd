extends State

var laser
onready var ACTIVE = $"../Active"

onready var timer = $Timer

var laser_alpha : float

func enter(_info):
	laser = fsm.actor
	laser.raycast.tween.interpolate_property(self, "laser_alpha", 0.0, 0.35, get_node("Timer").wait_time)
	laser.raycast.tween.start()
	timer.start()
	laser.raycast.set_laser_color(laser.FADED_RED)
	laser.raycast.shoot_at(laser.direction)

func process(delta):
	laser.raycast.set_laser_transparency(laser_alpha)

func _on_Timer_timeout():
	if fsm.current_state == self:
		fsm.change_state(ACTIVE)
