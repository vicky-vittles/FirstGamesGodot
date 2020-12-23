extends State

var player

func enter():
	player = fsm.actor
	player.animation_player.play("duck")

func exit():
	player.animation_player.play("stand")

func process(delta):
	player.get_input()
	player.flip(player.direction)
	
	if player.input_attack:
		fsm.change_state($"../DuckAttack")
	if not player.input_down:
		fsm.change_state($"../Idle")

func physics_process(delta):
	pass
