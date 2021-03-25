extends State

var human
onready var WALK = $"../Walk"
onready var JUMP = $"../Jump"

func enter():
	human = fsm.actor
	human.graphics.play_anim(Globals.HUMAN_IDLE_ANIM)

func input(event):
	human.event_input(event)

func process(delta):
	human.get_input()

func physics_process(delta):
	human.check_walk()
	human.check_crouch()
	human.air_movement(delta)
	if human.input.get_press("attack") and human.can_attack:
		fsm.change_state($"../Attack")
	elif human.input.get_press("jump") and not human.is_crouching:
		fsm.change_state(JUMP)
	elif human.move_direction != Vector3.ZERO:
		fsm.change_state(WALK)
