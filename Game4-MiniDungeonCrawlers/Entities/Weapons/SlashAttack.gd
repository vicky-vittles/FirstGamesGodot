extends State

var animated_angle = 0

func enter():
	randomize()
	var random_dir = pow(-1, randi() % 2)
	
	var aim_center = fsm.actor.player.get_node("AimCenter")
	
	var initial_angle = fsm.actor.direction.angle()
	var final_angle = initial_angle + random_dir * fsm.actor.angular_reach
	
	$Tween.interpolate_property(self, "animated_angle", initial_angle, final_angle, $AttackTimer.wait_time)
	
	if not $Tween.is_active():
		$Tween.start()
	
	animated_angle = initial_angle
	
	$AttackTimer.start()


func exit():
	pass


func physics_process(delta):
	
	var aim_center = fsm.actor.player.get_node("AimCenter")
	
	#var initial_direction = aim_center.global_position + fsm.actor.direction * fsm.actor.reach
	#var rotated_direction = fsm.actor.direction.rotated(deg2rad(fsm.actor.angular_reach * random_dir)) * fsm.actor.reach
	#var final_direction = aim_center.global_position + rotated_direction
	
	var rad = deg2rad(animated_angle)
	var new_position = aim_center.global_position + Vector2(sin(rad), cos(rad)) * fsm.actor.reach
	
	fsm.actor.global_position = new_position
	
	fsm.actor.look_at(aim_center.global_position)
	fsm.actor.rotate(-PI/2)


func _on_AttackTimer_timeout():
	fsm.change_state($"../Sheathed")
