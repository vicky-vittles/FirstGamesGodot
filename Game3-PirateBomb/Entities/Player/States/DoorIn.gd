extends State

var player

var has_entered_door = false
var direction
var door_pos
var door_animation_finished = false

func enter():
	player = fsm.actor
	has_entered_door = false
	
	var player_pos = player.global_position.x
	door_pos = player.door.global_position.x
	
	if player_pos != door_pos:
		if player_pos < door_pos:
			player.velocity.x = Player.RUN_SPEED
			direction = 1
			player.turn_around(1)
			player.animated_sprite.play("run")
		else:
			player.velocity.x = -Player.RUN_SPEED
			direction = -1
			player.turn_around(-1)
			player.animated_sprite.play("run")
	else:
		player.animated_sprite.play("door_in")
		
	player.acceleration.y = Player.JUMP_ASCENT_GRAVITY

func physics_process(delta):
	
	if door_animation_finished:
		
		door_animation_finished = false
		
		fsm.change_state($"../DoorOut")
	
	else:
	
		var previous_pos = player.global_position.x
		player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
		
		if direction == 1:
			player.global_position.x = clamp(player.global_position.x, previous_pos, door_pos)
		elif direction == -1:
			player.global_position.x = clamp(player.global_position.x, door_pos, previous_pos)
		
		if player.global_position.x == previous_pos:
			if not has_entered_door:
				player.door.enter()
			player.animated_sprite.play("door_in")
			has_entered_door = true
			player.velocity.x = 0

func _on_AnimatedSprite_animation_finished():
	if fsm.current_state == self and player.animated_sprite.animation == "door_in":
		door_animation_finished = true
		player.global_position = player.door.connected_door.get_node("PlayerTeleportPosition").global_position
		player.door.connected_door.enter()
		player.door.close()
		$"../DoorOut".door_to_exit = player.door.connected_door


func _on_Hurtbox_area_entered(area):
	if fsm.current_state == self and area.is_in_group("explosion"):
		var explosion = (area as Explosion)
		var hit_direction = (player.global_position - explosion.global_position).normalized()
		
		player.health.update_health(-area.hit.amount)
		
		if player.health.health > 0:
			$"../Hurt".set_direction(hit_direction)
			fsm.change_state($"../Hurt")
		else:
			$"../DeadHit".set_direction(hit_direction)
			fsm.change_state($"../DeadHit")
