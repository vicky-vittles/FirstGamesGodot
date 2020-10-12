extends State

func enter():
	pass

func exit():
	pass

func physics_process(delta):
	
	var p_index = str(fsm.actor.player.player_index)
	
	var horizontal_look = Input.get_action_strength("r_right_" + p_index) - Input.get_action_strength("r_left_" + p_index)
	var vertical_look = Input.get_action_strength("r_down_" + p_index) - Input.get_action_strength("r_up_" + p_index)
	var is_attacking = Input.is_action_pressed("attack_" + p_index)
	
	fsm.actor.direction = Vector2(horizontal_look, vertical_look).normalized()
	
	if fsm.actor.direction != Vector2.ZERO:
		var player = fsm.actor.player
		var aim_center_position = player.get_node("AimCenter").global_position
		var pos_in_circle = fsm.actor.direction * fsm.actor.reach
		
		fsm.actor.global_position = aim_center_position + pos_in_circle
		
		fsm.actor.look_at(aim_center_position)
		fsm.actor.rotate(-PI/2)
		
		if is_attacking:
			fsm.change_state($"../Attack")
		
	else:
		fsm.change_state($"../Sheathed")
