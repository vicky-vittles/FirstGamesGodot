extends State

onready var jump_press_timer = $JumpPressTimer

var player

func enter():
	player = fsm.actor
	player.acceleration.y = Player.JUMP_DESCENT_GRAVITY

func process(delta):
	player.get_input()

func physics_process(delta):
	
	player.animated_sprite.play("fall")
	
	if player.jump:
		if jump_press_timer.is_stopped():
			jump_press_timer.start()
	
	if player.is_on_floor():
		if jump_press_timer.time_left > 0 and not jump_press_timer.is_stopped():
			fsm.change_state($"../Jump")
		else:
			fsm.change_state($"../Ground")
	
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
