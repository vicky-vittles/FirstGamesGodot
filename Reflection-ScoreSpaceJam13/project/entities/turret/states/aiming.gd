extends State

var FOCUS_LEVEL : float = 0.08
var turret

var previous_pos = Vector2()

func enter(_info):
	turret = fsm.actor

func physics_process(delta):
	var target_pos = turret.get_parent().target.global_position
	var current_pos = lerp(previous_pos, target_pos, FOCUS_LEVEL)
	turret.look_at(current_pos)
	previous_pos = current_pos
