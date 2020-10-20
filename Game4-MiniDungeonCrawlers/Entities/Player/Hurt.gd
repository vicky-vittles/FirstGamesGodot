extends State

var duration_timeout

func enter():
	duration_timeout = false
	fsm.actor.get_node("AnimationPlayer").play("hit")
	
	$DurationTimer.start()
	fsm.actor.get_node("InvincibilityTimer").start()
	fsm.actor.get_node("Hurtbox/CollisionShape2D").set_deferred("disabled", true)

func exit():
	pass

func physics_process(delta):
	
	var p_index = str(fsm.actor.player_index)
	
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
