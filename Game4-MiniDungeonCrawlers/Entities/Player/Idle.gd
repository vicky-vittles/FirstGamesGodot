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
	var is_attacking = Input.is_action_pressed("attack_" + p_index)
	
	if is_attacking and fsm.actor.near_door != null and fsm.actor.get_node("Inventory").silver_keys > 0:
		(fsm.actor.near_door as Door).open()
		
		fsm.actor.get_node("Inventory").update_silver_keys(-1)
	
	var direction = Vector2(horizontal, vertical).normalized()
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
	
	if direction.x != 0 or direction.y != 0:
		fsm.change_state($"../Run")
	else:
		fsm.actor.get_node("AnimationPlayer").play("idle")


func _on_Hurtbox_area_entered(area):
	
	if (area.is_in_group("spike") or area.is_in_group("enemy_attack")) and fsm.current_state == self:
		fsm.actor.get_node("Health").update_health(-area.damage)
		fsm.change_state($"../Hurt")
