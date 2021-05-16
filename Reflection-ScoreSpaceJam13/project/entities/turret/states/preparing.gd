extends State

signal spawn_laser(pos, dir)

var turret
onready var AIMING = $"../Aiming"

func enter(_info):
	turret = fsm.actor

func physics_process(delta):
	var laser_pos = turret.laser_spawn_pos.global_position
	var laser_dir = turret.global_transform.x
	emit_signal("spawn_laser", laser_pos, laser_dir)
	fsm.change_state(AIMING)
