extends "res://Entities/Systems/Hurtbox.gd"

class_name StompableHurtbox

func get_stomped(hit):
	disable_shapes()
	#$"..".is_alive = false
	#$"..".velocity.x = 0
	$"..".GRAVITY = 0


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
		if hit.team == "player_stomp" and direction.y > 0.25:
			emit_signal("hit_landed", hit, direction)
			get_stomped(hit)
