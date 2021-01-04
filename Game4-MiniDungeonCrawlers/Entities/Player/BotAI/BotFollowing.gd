extends State

var player

func enter():
	player = fsm.actor

func exit():
	pass

func physics_process(_delta):
	var nearest_enemy = player.get_nearest_enemy()
	var player_on_dual_button = player.get_player_with_dual_button()
	
	if nearest_enemy:
		fsm.change_state($"../InCombat")
	elif player_on_dual_button and player_on_dual_button.dual_button:
		fsm.change_state($"../DualButton")
	
	player.move_to(player.main_player.position_for_bot.global_position)
	player.reset_attack()
