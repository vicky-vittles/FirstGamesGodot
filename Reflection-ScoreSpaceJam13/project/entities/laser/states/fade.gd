extends State

var laser

onready var timer = $Timer

var laser_alpha : float

func enter(_info):
	laser = fsm.actor
	laser.raycast.tween.interpolate_property(self, "laser_alpha", 1.0, 0.0, 0.1)
	laser.raycast.tween.start()
	timer.start()

func process(delta):
	laser.raycast.set_laser_transparency(laser_alpha)


func _on_Timer_timeout():
	if fsm.current_state == self:
		get_parent().call_deferred("remove_child", self)