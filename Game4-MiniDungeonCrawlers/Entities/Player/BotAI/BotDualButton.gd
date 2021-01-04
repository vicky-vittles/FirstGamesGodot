extends State

var player
var player_on_dual_button

func enter():
	player = fsm.actor
	player_on_dual_button = player.get_player_with_dual_button()

func exit():
	pass

func physics_process(_delta):
	
	if player_on_dual_button:
		if player_on_dual_button.dual_button:
			var move_target = player_on_dual_button.dual_button.other_button.global_position
			player.move_to(move_target)
		else:
			fsm.change_state($"../Following")
