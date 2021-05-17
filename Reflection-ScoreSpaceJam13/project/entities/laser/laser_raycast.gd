extends RayCast2D

const DIST : int = 2000

onready var tween = $Tween
onready var body = $Body


func set_laser_color(color: Color):
	body.default_color = color

func set_laser_transparency(alpha: float):
	body.default_color.a = alpha


func shoot_at(dir: Vector2):
	cast_to = dir * DIST
	force_raycast_update()
	
	var collision_point = global_position + dir * DIST
	if is_colliding():
		var collider = get_collider()
		if collider.is_in_group("mirror"):
			collision_point = get_collision_point()
	
	body.clear_points()
	body.add_point(Vector2.ZERO)
	body.add_point(collision_point - global_position)


func get_collision_with_mirror():
	if is_colliding():
		var collider = get_collider()
		if collider.is_in_group("mirror"):
			var collision_info = {
				"collider": collider,
				"collision_point": get_collision_point(),
				"collision_normal": get_collision_normal()}
			return collision_info
	return null


func get_collision_with_player():
	if is_colliding():
		var collider = get_collider()
		if collider.is_in_group("player"):
			collider.die()
