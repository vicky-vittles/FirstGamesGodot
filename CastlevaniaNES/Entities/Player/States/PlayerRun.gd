extends State

var player

func enter():
	player = fsm.actor
	player.animation_player.play("run")

func exit():
	pass

func process(delta):
	player.get_input()
	player.flip(player.direction)

func physics_process(delta):
	player.move(delta)
	
	if player.input_attack:
		fsm.change_state($"../Attack")
	elif player.input_down:
		fsm.change_state($"../Duck")
	elif player.input_jump:
		fsm.change_state($"../Jump")
	elif player.direction == 0:
		fsm.change_state($"../Idle")
