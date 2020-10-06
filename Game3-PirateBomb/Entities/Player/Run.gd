extends State

func _ready():
	$"../../Hurtbox".connect("area_entered", self, "_on_Hurtbox_area_entered")
	$"../../PunchHitbox".connect("area_entered", self, "_on_PunchHitbox_area_entered")

func enter():
	fsm.actor.acceleration.y = Player.JUMP_ASCENT_GRAVITY
	$"../../StepsOnWoodSFX".play_random()
	$"../../PunchHitbox/CollisionShape2D".set_deferred("disabled", false)

func exit():
	$"../../StepsOnWoodSFX".stop()
	$"../../PunchHitbox/CollisionShape2D".set_deferred("disabled", true)

func physics_process(delta):
	
	var left = Input.is_action_pressed("left_" + str(fsm.actor.player_index))
	var right = Input.is_action_pressed("right_" + str(fsm.actor.player_index))
	var jump = Input.is_action_just_pressed("jump_" + str(fsm.actor.player_index))
	var attack = Input.is_action_just_pressed("bomb_" + str(fsm.actor.player_index))
	
	if left and right:
		left = false
		right = false
	
	if attack:
		fsm.actor.place_bomb()
	
	if jump and fsm.actor.is_on_floor():
		fsm.change_state($"../Jump")
	
	if right:
		fsm.actor.velocity.x = Player.RUN_SPEED
		fsm.actor.turn_around(1)
		$"../../AnimatedSprite".play("run")
		
	elif left:
		fsm.actor.velocity.x = -Player.RUN_SPEED
		fsm.actor.turn_around(-1)
		$"../../AnimatedSprite".play("run")
		
	else:
		fsm.actor.velocity.x = 0
		fsm.change_state($"../Idle")
	
	fsm.actor.velocity.y += fsm.actor.acceleration.y * delta
	fsm.actor.velocity = fsm.actor.move_and_slide(fsm.actor.velocity, Vector2.UP)


func _on_Hurtbox_area_entered(area):
	if area.is_in_group("explosion") and fsm.current_state == self:
		var explosion = (area as Explosion)
		var hit_direction = (fsm.actor.global_position - explosion.global_position).normalized()
		
		$"../../Health".update_health(-area.hit.amount)
		
		if $"../../Health".health > 0:
			$"../Hurt".set_direction(hit_direction)
			fsm.change_state($"../Hurt")
		else:
			$"../DeadHit".set_direction(hit_direction)
			fsm.change_state($"../DeadHit")


func _on_PunchHitbox_area_entered(area):
	if area.is_in_group("bomb") and fsm.current_state == self and abs(fsm.actor.velocity.x) > 0:
		fsm.change_state($"../Attack")
