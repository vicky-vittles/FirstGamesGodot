extends State

var delta_sum : float = 0.0
var player

func enter():
	player = fsm.actor

func exit():
	pass

func physics_process(_delta):
	delta_sum += _delta
	var nearest_enemy = player.get_nearest_enemy()
	
	if nearest_enemy:
		var direction_to_enemy = player.global_position.direction_to(nearest_enemy.global_position)
		direction_to_enemy = direction_to_enemy.normalized()
		
		var move_offset = 20 * direction_to_enemy
		player.move_to(player.global_position + move_offset)
		player.attack_target(nearest_enemy.global_position)
	else:
		fsm.change_state($"../Following")
