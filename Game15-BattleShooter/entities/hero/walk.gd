extends State

onready var IDLE = $"../Idle"
var hero

func enter():
	hero = fsm.actor

func process(delta):
	hero.get_input()

func physics_process(delta):
	var angle_to_mouse = hero.get_angle_to_mouse()
	hero.graphics.play_walk(angle_to_mouse)
	hero.graphics.play_weapon(angle_to_mouse)
	hero.move(delta)
	
	if hero.direction == Vector2.ZERO:
		fsm.change_state(IDLE)
