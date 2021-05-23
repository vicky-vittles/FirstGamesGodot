extends State

var enemy
onready var DIE = $"../die"

func enter(_info):
	enemy = fsm.actor


func _on_Enemy_infected():
	if fsm.current_state == self:
		fsm.change_state(DIE)
