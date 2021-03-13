extends State

onready var DEAD = $"../Dead"
var rocket

func enter():
	rocket = fsm.actor

func physics_process(delta):
	rocket.set_target()
	rocket.move(delta)

func explode():
	fsm.change_state(DEAD)
