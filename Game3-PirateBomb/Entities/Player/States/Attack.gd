extends State

var player
var attack_animation_finished = false

func enter():
	player = fsm.actor
	player.velocity.x = 0
	player.acceleration.y = Player.JUMP_ASCENT_GRAVITY
	player.bomb_swish_sfx.play_random()
	player.animated_sprite.play("attack")

func exit():
	player.punch_hitbox_shape.disabled = true

func process(delta):
	player.get_input()

func physics_process(delta):
	
	if attack_animation_finished:
		
		attack_animation_finished = false
		
		if player.jump:
			fsm.change_state($"../Jump")
		elif player.right or player.left:
			fsm.change_state($"../Run")
		else:
			fsm.change_state($"../Idle")


func _on_AnimatedSprite_animation_finished():
	if fsm.current_state == self and player.animated_sprite.animation == "attack":
		attack_animation_finished = true


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
