extends "res://Entities/Player/Controllers/VirtualController.gd"

func get_input():
	
	if player.can_poll_input:
		var p_index = str(player.player_index)
		
		var horizontal = Input.get_action_strength("l_right_" + p_index) - Input.get_action_strength("l_left_" + p_index)
		var vertical = Input.get_action_strength("l_down_" + p_index) - Input.get_action_strength("l_up_" + p_index)
		player.is_attacking = Input.is_action_pressed("attack_" + p_index)
		
		player.walk_direction = Vector2(horizontal, vertical).normalized()
		
		if player.player_index > 1:
			var horizontal_look = Input.get_action_strength("r_right_" + p_index) - Input.get_action_strength("r_left_" + p_index)
			var vertical_look = Input.get_action_strength("r_down_" + p_index) - Input.get_action_strength("r_up_" + p_index)
			player.look_direction = Vector2(horizontal_look, vertical_look).normalized()
		else:
			player.look_direction = player.global_position.direction_to(player.get_global_mouse_position())
