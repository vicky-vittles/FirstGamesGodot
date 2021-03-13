extends State

onready var IDLE = $"../Idle"
var rocket

func enter():
	rocket = fsm.actor

func _on_AnimationPlayer_animation_finished(anim_name):
	if fsm.current_state == self and anim_name == "explode":
		rocket.global_position = rocket.spawn_pos
		fsm.change_state(IDLE)
