extends State

var attack_animation_finished = false

func _ready():
	$"../../AnimatedSprite".connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	$"../../Hurtbox".connect("area_entered", self, "_on_Hurtbox_area_entered")

func enter():
	fsm.actor.velocity.x = 0
	fsm.actor.acceleration.y = Player.JUMP_ASCENT_GRAVITY
	$"../../BombSwishSFX".play_random()
	$"../../AnimatedSprite".play("attack")

func exit():
	$"../../PunchHitbox/CollisionShape2D".disabled = true

func physics_process(delta):
	
	var left = Input.is_action_pressed("left_" + str(fsm.actor.player_index))
	var right = Input.is_action_pressed("right_" + str(fsm.actor.player_index))
	var jump = Input.is_action_just_pressed("jump_" + str(fsm.actor.player_index))
	
	if left and right:
		left = false
		right = false
	
	if attack_animation_finished:
		
		attack_animation_finished = false
		
		if jump:
			fsm.change_state($"../Jump")
		elif right or left:
			fsm.change_state($"../Run")
		else:
			fsm.change_state($"../Idle")


func _on_AnimatedSprite_animation_finished():
	if $"../../AnimatedSprite".animation == "attack" and fsm.current_state == self:
		attack_animation_finished = true


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
