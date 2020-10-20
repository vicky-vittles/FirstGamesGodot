extends State

func enter():
	pass

func exit():
	pass

func physics_process(delta):
	
	var user = fsm.actor.user
	user.poll_input()
	
	fsm.actor.direction = user.look_direction
	
	if fsm.actor.direction != Vector2.ZERO:
		var aim_center_position = user.get_node("AimCenter").global_position
		var pos_in_circle = fsm.actor.direction * fsm.actor.reach
		
		fsm.actor.global_position = aim_center_position + pos_in_circle
		
		fsm.actor.look_at(aim_center_position)
		fsm.actor.rotate(-PI/2)
		
		if user.is_attacking:
			fsm.change_state($"../Attack")
		
	else:
		fsm.change_state($"../Sheathed")
