extends State

var player

func enter():
	player = fsm.actor
	player.acceleration.y = Player.JUMP_ASCENT_GRAVITY
	player.steps_on_wood_sfx.play_random()
	player.punch_hitbox_shape.set_deferred("disabled", false)

func exit():
	player.steps_on_wood_sfx.stop()
	player.punch_hitbox_shape.set_deferred("disabled", true)

func process(delta):
	player.get_input()

func physics_process(delta):
	
	if player.attack:
		player.place_bomb()
	
	if player.jump and player.is_on_floor():
		fsm.change_state($"../Jump")
	
	if player.right:
		player.velocity.x = Player.RUN_SPEED
		player.turn_around(1)
		player.animated_sprite.play("run")
		
	elif player.left:
		player.velocity.x = -Player.RUN_SPEED
		player.turn_around(-1)
		player.animated_sprite.play("run")
		
	else:
		player.velocity.x = 0
		fsm.change_state($"../Idle")
	
	player.move_y(delta)


func _on_Hurtbox_area_entered(area):
	if area.is_in_group("explosion") and fsm.current_state == self:
		var explosion = (area as Explosion)
		var hit_direction = (player.global_position - explosion.global_position).normalized()
		
		player.health.update_health(-area.hit.amount)
		
		if player.health.health > 0:
			$"../Hurt".set_direction(hit_direction)
			fsm.change_state($"../Hurt")
		else:
			$"../DeadHit".set_direction(hit_direction)
			fsm.change_state($"../DeadHit")


func _on_PunchHitbox_area_entered(area):
	if area.is_in_group("bomb") and fsm.current_state == self and abs(player.velocity.x) > 0:
		fsm.change_state($"../Attack")
