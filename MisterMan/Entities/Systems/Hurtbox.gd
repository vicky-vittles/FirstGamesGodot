extends Area2D

class_name Hurtbox

signal hit_landed(hit, direction)

export (bool) var is_invincible = false


func disable_shapes():
	for i in get_child_count():
		var child = get_child(i)
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)


func _on_area_shape_entered(area_id, area, area_shape, self_shape):
	var hit = area.hit
	
	var direction = Vector2()
	if global_position.x <= area.global_position.x:
		direction.x = -1
	else:
		direction.x = 1
	
	if global_position.y >= area.global_position.y:
		direction.y = 1
	else:
		direction.y = -1
	
	if not is_in_group(hit.team):
		emit_signal("hit_landed", hit, direction)
