extends State

func enter():
	fsm.actor.global_position = fsm.actor.player.get_node("AimCenter").global_position

func exit():
	pass

func physics_process(delta):
	
	var p_index = str(fsm.actor.player.player_index)
	
	var horizontal = Input.get_action_strength("l_right_" + p_index) - Input.get_action_strength("l_left_" + p_index)
	var vertical = Input.get_action_strength("l_down_" + p_index) - Input.get_action_strength("l_up_" + p_index)
	var horizontal_look = Input.get_action_strength("r_right_" + p_index) - Input.get_action_strength("r_left_" + p_index)
	var vertical_look = Input.get_action_strength("r_down_" + p_index) - Input.get_action_strength("r_up_" + p_index)
	var is_attacking = Input.is_action_pressed("attack_" + p_index)
	
	var direction = Vector2(horizontal, vertical).normalized()
	fsm.actor.direction = Vector2(horizontal_look, vertical_look).normalized()
	
	if fsm.actor.direction != Vector2.ZERO:
		fsm.change_state($"../Ready")
		
	else:
		
		if direction != Vector2.ZERO:
			fsm.actor.direction = Vector2(sign(direction.x), sign(direction.y))
		
		if is_attacking:
			fsm.change_state($"../Attack")
		
		if direction.x > 0:
			fsm.actor.rotation = -130
		elif direction.x < 0:
			fsm.actor.rotation = 130
