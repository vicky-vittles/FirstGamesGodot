extends State

func _ready():
	$"../../Hurtbox".connect("area_entered", self, "_on_Hurtbox_area_entered")

func enter():
	fsm.actor.velocity.y = Player.JUMP_ASCENT_SPEED
	fsm.actor.acceleration.y = Player.JUMP_ASCENT_GRAVITY

func exit():
	pass

func physics_process(delta):
	
	$"../../AnimatedSprite".play("jump")
	
	var left = Input.is_action_pressed("left_" + str(fsm.actor.player_index))
	var right = Input.is_action_pressed("right_" + str(fsm.actor.player_index))
	
	if left and right:
		left = false
		right = false
	
	if fsm.actor.velocity.y > 0:
		fsm.change_state($"../Fall")
	
	if right:
		fsm.actor.velocity.x = Player.RUN_SPEED
		fsm.actor.turn_around(1)
	elif left:
		fsm.actor.velocity.x = -Player.RUN_SPEED
		fsm.actor.turn_around(-1)
	else:
		fsm.actor.velocity.x = 0
	
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
