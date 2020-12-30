extends State

var player

func enter():
	player = fsm.actor
	player.velocity.y = Player.JUMP_ASCENT_SPEED
	player.acceleration.y = Player.JUMP_ASCENT_GRAVITY

func process(delta):
	player.get_input()

func physics_process(delta):
	
	player.animated_sprite.play("jump")
	
	if player.velocity.y > 0:
		fsm.change_state($"../Fall")
	
	if player.right:
		player.velocity.x = Player.RUN_SPEED
		player.turn_around(1)
	elif player.left:
		player.velocity.x = -Player.RUN_SPEED
		player.turn_around(-1)
	else:
		player.velocity.x = 0
	
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
