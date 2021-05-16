extends State

var laser
onready var FADE = $"../Fade"

onready var timer = $Timer

var laser_alpha : float

func enter(_info):
	laser = fsm.actor
	laser.raycast.tween.interpolate_property(self, "laser_alpha", 0.7, 1.0, 0.05)
	laser.raycast.tween.start()
	timer.wait_time = laser.ACTIVE_TIME
	timer.start()

func process(delta):
	laser.raycast.set_laser_transparency(laser_alpha)

func physics_process(delta):
	laser.raycast.get_collision_with_player()

func _on_Timer_timeout():
	if fsm.current_state == self:
		
		var collision = laser.raycast.get_collision_with_mirror()
		if collision:
			var collider = collision["collider"]
			var collision_point = collision["collision_point"]
			var collision_normal = collision["collision_normal"]
			var new_direction = laser.direction.bounce(collision_normal)
			collision_point += new_direction*Vector2(1,1)
			laser.spawn_copy(collision_point, new_direction)
		
		fsm.change_state(FADE)
