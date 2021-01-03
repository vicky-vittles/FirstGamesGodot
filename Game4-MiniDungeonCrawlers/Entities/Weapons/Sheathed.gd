extends State

var weapon

func enter():
	weapon = fsm.actor
	weapon.global_position = weapon.user.get_node("AimCenter").global_position

func exit():
	pass

func physics_process(_delta):
	
	var user = weapon.user
	user.poll_input()
	
	var direction = user.walk_direction
	weapon.direction = user.look_direction
	
	if weapon.direction != Vector2.ZERO:
		fsm.change_state($"../Ready")
		
	else:
		if direction != Vector2.ZERO:
			weapon.direction = Vector2(sign(direction.x), sign(direction.y))
		
		if direction.x > 0:
			weapon.rotation = -130
		elif direction.x < 0:
			weapon.rotation = 130
