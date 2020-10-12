extends State

func enter():
	$"../../Hurtbox".connect("area_entered", self, "_on_Hurtbox_area_entered")

func exit():
	pass

func physics_process(delta):
	
	var p_index = str(fsm.actor.player_index)
	
	var horizontal = Input.get_action_strength("l_right_" + p_index) - Input.get_action_strength("l_left_" + p_index)
	var vertical = Input.get_action_strength("l_down_" + p_index) - Input.get_action_strength("l_up_" + p_index)
	var horizontal_look = Input.get_action_strength("r_right_" + p_index) - Input.get_action_strength("r_left_" + p_index)
	var vertical_look = Input.get_action_strength("r_down_" + p_index) - Input.get_action_strength("r_up_" + p_index)
	
	var direction = Vector2(horizontal, vertical).normalized()
	if direction != Vector2.ZERO:
		fsm.actor.last_direction = direction
	fsm.actor.look_direction = Vector2(horizontal_look, vertical_look).normalized()
	
	if fsm.actor.look_direction.x > 0:
		fsm.actor.turn_around(1)
	elif fsm.actor.look_direction.x < 0:
		fsm.actor.turn_around(-1)
	else:
		if direction.x > 0:
			fsm.actor.turn_around(1)
		elif direction.x < 0:
			fsm.actor.turn_around(-1)
	
	if direction.x == 0 and direction.y == 0:
		fsm.change_state($"../Idle")
	else:
		fsm.actor.get_node("AnimationPlayer").play("run")
	
	fsm.actor.velocity = direction * fsm.actor.SPEED
	
	fsm.actor.velocity = fsm.actor.move_and_slide(fsm.actor.velocity, Vector2.UP)


func _on_Hurtbox_area_entered(area):
	if area.is_in_group("enemy_attack") and fsm.current_state == self:
		fsm.change_state($"../Hurt")
