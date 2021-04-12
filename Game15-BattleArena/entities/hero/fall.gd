extends State

onready var IDLE = $"../Idle"
onready var RUN = $"../Run"
var hero

func enter():
	hero = fsm.actor

func process(delta):
	hero.get_input()

func physics_process(delta):
	hero.graphics.facing(hero.direction.x)
	hero.apply_speed()
	hero.apply_gravity(delta)
	hero.move(delta)
	
	if hero.is_on_ground():
		if hero.direction.x != 0:
			fsm.change_state(RUN)
		else:
			fsm.change_state(IDLE)
