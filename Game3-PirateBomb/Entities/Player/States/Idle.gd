extends State

var player

func enter():
	player = fsm.actor
	player.acceleration.y = Player.JUMP_ASCENT_GRAVITY

func process(delta):
	player.get_input()

func physics_process(delta):
	
	if player.attack:
		player.place_bomb()
	
	if player.up and player.can_enter_doors:
		fsm.change_state($"../DoorIn")
	elif player.jump and player.is_on_floor():
		fsm.change_state($"../Jump")
	elif player.right or player.left:
		fsm.change_state($"../Run")
	else:
		player.animated_sprite.play("idle")
	
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