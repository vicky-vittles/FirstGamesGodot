extends State

var human
onready var IDLE = $"../Idle"
onready var JUMP = $"../Jump"
onready var WALK= $"../Walk"
onready var CROUCH = $"../Crouch"

func enter():
	human = fsm.actor
	human.graphics.play_anim(Globals.HUMAN_WALK_ANIM)

func input(event):
	human.event_input(event)

func process(delta):
	human.get_input()

func physics_process(delta):
	human.full_movement(delta)
	if human.input.get_press("attack") and human.can_attack:
		fsm.change_state($"../Attack")
	elif human.input.get_press("jump"):
		fsm.change_state(JUMP)
	elif human.input.get_press("crouch") and not human.head.is_colliding:
		fsm.change_state(CROUCH)
	elif human.input.get_press("walk"):
		fsm.change_state(WALK)
	elif human.move_direction.length() == 0:
		fsm.change_state(IDLE)
