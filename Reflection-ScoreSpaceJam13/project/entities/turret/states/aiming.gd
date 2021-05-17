extends State

var FOCUS_LEVEL : float = 0.08
var turret
onready var SHOOTING = $"../Shooting"
onready var DESTROYED = $"../Destroyed"
onready var TURN_OFF = $"../TurnOff"

var aim_alpha : float
var previous_pos = Vector2()

func enter(_info):
	turret = fsm.actor
	get_node("Tween").interpolate_property(self, "aim_alpha", 0.0, 0.35, 1.5)
	get_node("Tween").start()
	get_node("Timer").start()

func exit():
	turret.aim.set_aim_transparency(0.0)

func physics_process(delta):
	turret.aim.set_aim_color(aim_alpha)
	turret.aim.set_aim_transparency(clamp(aim_alpha*3, 0.0, 1.0))
	var target_pos = turret.get_parent().target.global_position
	var current_pos = lerp(previous_pos, target_pos, FOCUS_LEVEL)
	turret.look_at(current_pos)
	previous_pos = current_pos


func _on_Timer_timeout():
	if fsm.current_state == self:
		fsm.change_state(SHOOTING)


func _on_Hurtbox_destroyed():
	if fsm.current_state == self:
		fsm.change_state(DESTROYED)


func _on_Turret_turn_off():
	if fsm.current_state == self:
		fsm.change_state(TURN_OFF)
