extends State

onready var WALK = $"../Walk"
var hero

func enter():
	hero = fsm.actor

func process(delta):
	hero.get_input()

func physics_process(delta):
	hero.graphics.play_idle(hero.get_angle_to_mouse())
	if hero.direction != Vector2.ZERO:
		fsm.change_state(WALK)
