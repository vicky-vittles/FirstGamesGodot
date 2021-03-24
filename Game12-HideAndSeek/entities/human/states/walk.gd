extends State

var human
onready var IDLE = $"../Idle"
onready var JUMP = $"../Jump"

func enter():
	human = fsm.actor
	human.graphics.play_anim(Globals.HUMAN_WALK_ANIM)

func input(event):
	human.event_input(event)

func process(delta):
	human.get_input()

func physics_process(delta):
	human.full_movement(delta)
	if human.input.get_press("jump"):
		fsm.change_state(JUMP)
	elif human.move_direction == Vector3.ZERO:
		fsm.change_state(IDLE)
