extends State

var human
onready var IDLE = $"../Idle"

func enter():
	human = fsm.actor
	human.attack_start()

func exit():
	human.attack_end()

func input(event):
	human.event_input(event)

func process(delta):
	human.get_input()

func physics_process(delta):
	human.full_movement(delta)

func _on_AnimationPlayer_animation_finished(anim_name):
	if fsm.current_state == self and anim_name == "attack":
		fsm.change_state(IDLE)
