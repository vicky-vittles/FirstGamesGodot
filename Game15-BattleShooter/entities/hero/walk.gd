extends State

onready var IDLE = $"../Idle"
var hero

func enter():
	hero = fsm.actor

func exit():
	hero.graphics.stop_anim()

func process(delta):
	hero.get_input()

func physics_process(delta):
	hero.graphics.play_walk()
	hero.move(delta)
	if hero.direction == Vector2.ZERO:
		fsm.change_state(IDLE)
