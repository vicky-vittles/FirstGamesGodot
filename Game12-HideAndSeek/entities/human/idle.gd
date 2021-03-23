extends State

var human
onready var WALK = $"../Walk"

func enter():
	human = fsm.actor
	human.graphics.play_anim(Globals.HUMAN_IDLE_ANIM)

func physics_process(_delta):
	human.get_input()
	if human.input.get_press("attack"):
		fsm.change_state(WALK)
