extends "res://Entities/Systems/Hurtbox.gd"

signal defended_hit(hit, direction)

class_name ProtectorHurtbox

export (PoolStringArray) var exceptions = []

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
		var is_in_exceptions = false
		for i in exceptions.size():
			if hit.team == exceptions[i]:
				is_in_exceptions = true
		
		if is_in_exceptions:
			emit_signal("defended_hit", hit, direction)
