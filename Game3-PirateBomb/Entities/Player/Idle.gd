extends State

func _ready():
	$"../../Hurtbox".connect("area_entered", self, "_on_Hurtbox_area_entered")

func enter():
	fsm.actor.acceleration.y = Player.JUMP_ASCENT_GRAVITY

func exit():
	pass

func physics_process(delta):
	
	var left = Input.is_action_pressed("left_" + str(fsm.actor.player_index))
	var right = Input.is_action_pressed("right_" + str(fsm.actor.player_index))
	var up = Input.is_action_pressed("up_" + str(fsm.actor.player_index))
	var jump = Input.is_action_just_pressed("jump_" + str(fsm.actor.player_index))
	var attack = Input.is_action_just_pressed("bomb_" + str(fsm.actor.player_index))
	
	if left and right:
		left = false
		right = false
	
	if attack:
		fsm.actor.place_bomb()
	
	if up and fsm.actor.can_enter_doors:
		fsm.change_state($"../DoorIn")
	elif jump and fsm.actor.is_on_floor():
		fsm.change_state($"../Jump")
	elif right or left:
		fsm.change_state($"../Run")
	else:
		$"../../AnimatedSprite".play("idle")
	
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
