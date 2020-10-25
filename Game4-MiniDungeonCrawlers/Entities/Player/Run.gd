extends State

var player

func enter():
	$"../../Hurtbox".connect("area_entered", self, "_on_Hurtbox_area_entered")

func exit():
	pass

func physics_process(delta):
	
	player = fsm.actor
	player.poll_input()
	
	if player.is_attacking and player.near_door != null and player.get_node("Inventory").silver_keys > 0:
		(player.near_door as Door).open()
		
		player.get_node("Inventory").update_silver_keys(-1)
	
	var direction = player.walk_direction
	if direction != Vector2.ZERO:
		player.last_direction = direction
	
	if player.look_direction.x > 0:
		player.turn_around(1)
	elif player.look_direction.x < 0:
		player.turn_around(-1)
	else:
		if direction.x > 0:
			player.turn_around(1)
		elif direction.x < 0:
			player.turn_around(-1)
	
	if direction.x == 0 and direction.y == 0:
		fsm.change_state($"../Idle")
	else:
		player.get_node("AnimationPlayer").play("run")
	
	player.velocity = direction * player.SPEED
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	#var camera_pos = player.camera.get_camera_screen_center()
	#player.global_position.x = clamp(player.global_position.x, camera_pos.x-256, camera_pos.x+256)
	#player.global_position.y = clamp(player.global_position.y, camera_pos.y-90, camera_pos.y+90)


func _on_Hurtbox_area_entered(area):
	
	if (area.is_in_group("spike") or area.is_in_group("enemy_attack")) and fsm.current_state == self:
		player.get_node("Health").update_health(-area.damage)
		fsm.change_state($"../Hurt")
