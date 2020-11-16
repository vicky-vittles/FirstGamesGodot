extends State

var player

func enter():
	player = fsm.actor
	player.animation_player.play("idle")

func exit():
	pass

func process(delta):
	player.get_input()
	player.flip(player.direction)
	
	if player.input_jump:
		fsm.change_state($"../Jump")
	elif player.direction != 0:
		fsm.change_state($"../Run")

func physics_process(delta):
	player.move(delta)
