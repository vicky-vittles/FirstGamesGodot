extends State

var laser
onready var FADE = $"../Fade"

onready var timer = $Timer

var laser_alpha : float
var has_spawned_copy : bool = false

func enter(_info):
	laser = fsm.actor
	laser.raycast.tween.interpolate_property(self, "laser_alpha", 0.7, 1.0, get_node("Timer").wait_time)
	laser.raycast.tween.start()
	timer.start()
	laser.raycast.set_laser_color(laser.STRONG_COLOR)
	laser.raycast.shoot_at(laser.direction)
	laser.animation_player.play("shoot")
	has_spawned_copy = false

func process(delta):
	laser.raycast.set_laser_transparency(laser_alpha)

func physics_process(delta):
	laser.raycast.get_collision_with_player()
	if not has_spawned_copy:
		spawn_copy()

func spawn_copy():
	var collision = laser.raycast.get_collision_with_mirror()
	if collision:
		var collider = collision["collider"]
		var collision_point = collision["collision_point"]
		var collision_normal = collision["collision_normal"]
		var new_direction = laser.direction.bounce(collision_normal)
		collision_point += new_direction*Vector2(1,1)
		laser.spawn_copy(collision_point, new_direction, laser.laser_level, false)
	has_spawned_copy = true

func _on_Timer_timeout():
	if fsm.current_state == self:
		fsm.change_state(FADE)
