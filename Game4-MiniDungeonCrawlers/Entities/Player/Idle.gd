extends State

var player

func enter():
	player = fsm.actor
	player.hurtbox.connect("area_entered", self, "_on_Hurtbox_area_entered")

func exit():
	pass

func physics_process(delta):
	
	var p_index = str(player.player_index)
	
	var horizontal = Input.get_action_strength("l_right_" + p_index) - Input.get_action_strength("l_left_" + p_index)
	var vertical = Input.get_action_strength("l_down_" + p_index) - Input.get_action_strength("l_up_" + p_index)
	var horizontal_look = Input.get_action_strength("r_right_" + p_index) - Input.get_action_strength("r_left_" + p_index)
	var vertical_look = Input.get_action_strength("r_down_" + p_index) - Input.get_action_strength("r_up_" + p_index)
	var is_attacking = Input.is_action_pressed("attack_" + p_index)
	
	if is_attacking and player.near_door != null and player.inventory.silver_keys > 0:
		(player.near_door as Door).open()
		
		player.inventory.update_silver_keys(-1)
	
	var direction = Vector2(horizontal, vertical).normalized()
	player.look_direction = Vector2(horizontal_look, vertical_look).normalized()
	
	if player.look_direction.x > 0:
		player.turn_around(1)
	elif player.look_direction.x < 0:
		player.turn_around(-1)
	else:
		if direction.x > 0:
			player.turn_around(1)
		elif direction.x < 0:
			player.turn_around(-1)
	
	if direction.x != 0 or direction.y != 0:
		fsm.change_state($"../Run")
	else:
		player.animation_player.play("idle")


func _on_Hurtbox_area_entered(area):
	
	if (area.is_in_group("spike") or area.is_in_group("enemy_attack")) and fsm.current_state == self:
		player.health.update_health(-area.damage)
		
		$"../Hurt".knockback_direction = Vector2.ZERO
		if (area is Spike):
			var spike = area as Spike
			var hit_direction = (player.global_position - spike.global_position).normalized()
			hit_direction.x = sign(hit_direction.x) if abs(hit_direction.x) > 0.75 else 0
			hit_direction.y = sign(hit_direction.y) if abs(hit_direction.y) > 0.75 else 0
			
			$"../Hurt".knockback_direction = hit_direction
		
		fsm.change_state($"../Hurt")
