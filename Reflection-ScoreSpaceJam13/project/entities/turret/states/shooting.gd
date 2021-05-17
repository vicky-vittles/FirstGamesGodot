extends State

signal spawn_laser(pos, dir, level, is_immediate)

const STARTING_LASER_LEVEL : int = 4

var turret
onready var AIMING = $"../Aiming"
onready var DESTROYED = $"../Destroyed"
onready var TURN_OFF = $"../TurnOff"

func enter(_info):
	turret = fsm.actor
	var laser_pos = turret.laser_spawn_pos.global_position
	var laser_dir = turret.global_transform.x
	turret.animation_player.play("shoot")
	emit_signal("spawn_laser", laser_pos, laser_dir, STARTING_LASER_LEVEL, true)
	get_node("Timer").start()


func _on_Timer_timeout():
	if fsm.current_state == self:
		fsm.change_state(AIMING)


func _on_Hurtbox_destroyed():
	if fsm.current_state == self:
		fsm.change_state(DESTROYED)


func _on_Turret_turn_off():
	if fsm.current_state == self:
		fsm.change_state(TURN_OFF)
