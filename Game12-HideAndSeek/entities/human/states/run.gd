extends State

var human
onready var IDLE = $"../Idle"
onready var JUMP = $"../Jump"
onready var WALK= $"../Walk"
onready var CROUCH = $"../Crouch"
onready var DEAD = $"../Dead"

func enter():
	human = fsm.actor
	human.graphics.play_anim(Globals.HUMAN_WALK_ANIM)

func exit():
	human.graphics.reset_anim()

func input(event):
	human.event_input(event)

func process(delta):
	human.get_input()

func physics_process(delta):
	var is_crouch = human.input.get_consume("crouch") or human.input.get_press("crouch")
	human.full_movement(delta)
	human.steps_sfx.play_random()
	
	if human.input.get_press("attack") and human.can_attack:
		fsm.change_state($"../Attack")
	elif human.input.get_press("jump"):
		fsm.change_state(JUMP)
	elif is_crouch and not human.head.is_colliding:
		human.input.consume("crouch")
		fsm.change_state(CROUCH)
	elif human.input.get_press("walk"):
		fsm.change_state(WALK)
	elif human.move_direction.length() == 0:
		fsm.change_state(IDLE)

func _on_Human_died(_human):
	if fsm.current_state == self:
		fsm.change_state(DEAD)
