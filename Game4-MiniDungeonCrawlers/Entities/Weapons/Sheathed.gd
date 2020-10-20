extends State

func enter():
	fsm.actor.global_position = fsm.actor.user.get_node("AimCenter").global_position

func exit():
	pass

func physics_process(delta):
	
	var user = fsm.actor.user
	user.poll_input()
	
	var direction = user.walk_direction
	fsm.actor.direction = user.look_direction
	
	if fsm.actor.direction != Vector2.ZERO:
		fsm.change_state($"../Ready")
		
	else:
		if direction != Vector2.ZERO:
			fsm.actor.direction = Vector2(sign(direction.x), sign(direction.y))
		
		if user.is_attacking:
			fsm.change_state($"../Attack")
		
		if direction.x > 0:
			fsm.actor.rotation = -130
		elif direction.x < 0:
			fsm.actor.rotation = 130
