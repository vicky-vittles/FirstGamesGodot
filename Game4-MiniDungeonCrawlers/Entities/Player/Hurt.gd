extends State

const KNOCKBACK_DISTANCE = 70

var player

var duration_timeout
var knockback_direction

func enter():
	player = fsm.actor
	
	duration_timeout = false
	player.animation_player.play("hit")
	
	$DurationTimer.start()
	player.invincibility_timer.start()
	player.hurtbox_collision_shape.set_deferred("disabled", true)

func exit():
	pass

func physics_process(_delta):
	
	if knockback_direction != Vector2.ZERO:
		player.velocity = player.move_and_slide(knockback_direction * KNOCKBACK_DISTANCE)
	
	var p_index = str(player.player_index)
		
	var horizontal = Input.get_action_strength("l_right_" + p_index) - Input.get_action_strength("l_left_" + p_index)
	var vertical = Input.get_action_strength("l_down_" + p_index) - Input.get_action_strength("l_up_" + p_index)
	
	var direction = Vector2(horizontal, vertical).normalized()
	
	if duration_timeout:
		if direction != Vector2.ZERO:
			fsm.change_state($"../Run")
		else:
			fsm.change_state($"../Idle")

func _on_DurationTimer_timeout():
	duration_timeout = true
