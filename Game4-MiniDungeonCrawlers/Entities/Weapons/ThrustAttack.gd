extends State

var velocity
var is_attack_finished

func enter():
	fsm.actor.get_node("CollisionShape2D").set_deferred("disabled", false)
	
	$DurationTimer.wait_time = fsm.actor.attack_duration
	$CooldownTimer.wait_time = fsm.actor.attack_duration
	
	$DurationTimer.start()
	velocity = fsm.actor.direction * fsm.actor.speed
	is_attack_finished = false

func exit():
	fsm.actor.get_node("CollisionShape2D").set_deferred("disabled", true)

func physics_process(delta):
	
	var user = fsm.actor.user
	
	if not is_attack_finished:
		fsm.actor.global_position += velocity * delta
	
	else:
		user.poll_input()
		
		if user.is_attacking:
			var aim_center_position = user.get_node("AimCenter").global_position
			fsm.actor.direction = user.look_direction
			
			var pos_in_circle = fsm.actor.direction * fsm.actor.reach
			
			fsm.actor.global_position = aim_center_position + pos_in_circle
			fsm.actor.look_at(aim_center_position)
			fsm.actor.rotate(-PI/2)
		
			fsm.change_state($"../Attack")
		
		else:
			fsm.change_state($"../Ready")

func _on_DurationTimer_timeout():
	velocity = -1 * fsm.actor.direction * fsm.actor.speed
	$CooldownTimer.start()

func _on_CooldownTimer_timeout():
	is_attack_finished = true
