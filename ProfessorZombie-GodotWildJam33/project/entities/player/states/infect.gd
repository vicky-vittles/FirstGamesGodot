extends State

var player
var infected_enemy
onready var MOVE = $"../move"

func enter(info):
	player = fsm.actor
	infected_enemy = info["infect_collider"]
	
	player.graphics.infect_pivot.play_infect(infected_enemy)
	infected_enemy.disable_enemy()

func _on_infect_animation_finished():
	if fsm.current_state == self:
		infected_enemy.infect()
		fsm.change_state(MOVE)
