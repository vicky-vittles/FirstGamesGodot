extends State

export (float) var stun_time = 0.5

func _ready():
	$StunTimer.wait_time = stun_time

func enter():
	$StunTimer.start()
	fsm.actor.velocity = Vector2(0, 0)

func exit():
	pass

func physics_process(delta):
	pass

func _on_StunTimer_timeout():
	if fsm.actor.nearest_player == null:
		fsm.change_state($"../Idle")
	else:
		fsm.change_state($"../Run")
