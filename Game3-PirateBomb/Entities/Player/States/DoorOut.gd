extends State

var player
var door_to_exit

var door_animation_finished = false

func enter():
	player = fsm.actor
	player.animated_sprite.play("door_out")
	player.acceleration.y = Player.JUMP_ASCENT_GRAVITY

func physics_process(delta):
	
	if door_animation_finished:
		
		door_animation_finished = false
		
		fsm.change_state($"../Idle")

func _on_AnimatedSprite_animation_finished():
	if fsm.current_state == self and player.animated_sprite.animation == "door_out":
		door_animation_finished = true
		door_to_exit.close()

func _on_Hurtbox_area_entered(area):
	if fsm.current_state == self and area.is_in_group("explosion"):
		var explosion = (area as Explosion)
		var hit_direction = (player.global_position - explosion.global_position).normalized()
		
		player.health.update_health(-area.hit.amount)
		
		if player.health.health > 0:
			$"../Hurt".set_direction(hit_direction)
			fsm.change_state($"../Hurt")
		else:
			$"../DeadHit".set_direction(hit_direction)
			fsm.change_state($"../DeadHit")
