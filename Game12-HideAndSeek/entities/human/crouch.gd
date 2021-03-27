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
	var is_crouch = human.input.get_consume("crouch") or human.input.get_press("crouch")
	human.full_movement(delta)
	if is_crouch and not human.head.is_colliding:
		human.input.consume("crouch")
		fsm.change_state(IDLE)
