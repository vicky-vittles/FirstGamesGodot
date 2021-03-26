extends State

var human
onready var IDLE = $"../Idle"

func enter():
	human = fsm.actor
	human.character_mover.set_slow_speed()
	human.animation_player.play("crouch")

func exit():
	human.character_mover.set_run_speed()
	human.animation_player.play("stand_up")

func input(event):
	human.event_input(event)

func process(delta):
	human.get_input()

func physics_process(delta):
	human.full_movement(delta)
	if human.input.get_press("crouch") and not human.head.is_colliding:
		fsm.change_state(IDLE)
