extends State

var player

func enter():
	player = fsm.actor
	player.hurtbox.connect("area_entered", self, "_on_Hurtbox_area_entered")

func exit():
	pass

func physics_process(_delta):
	
	player.poll_input()
	
	if player.is_attacking and player.near_door != null and player.inventory.silver_keys > 0:
		(player.near_door as Door).open()
		
		player.inventory.update_silver_keys(-1)
	
	if player.look_direction.x > 0:
		player.turn_around(1)
	elif player.look_direction.x < 0:
		player.turn_around(-1)
	else:
		if player.walk_direction.x > 0:
			player.turn_around(1)
		elif player.walk_direction.x < 0:
			player.turn_around(-1)
	
	if player.walk_direction.x != 0 or player.walk_direction.y != 0:
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
