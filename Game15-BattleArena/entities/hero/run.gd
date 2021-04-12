extends State

onready var IDLE = $"../Idle"
onready var JUMP = $"../Jump"
var hero

func enter():
	hero = fsm.actor
	hero.graphics.play_anim(Strings.RUN)

func process(delta):
	hero.get_input()

func physics_process(delta):
	hero.graphics.facing(hero.direction.x)
	hero.apply_speed()
	hero.apply_gravity(delta)
	hero.move(delta)
	
	if hero.jump_press:
		fsm.change_state(JUMP)
	elif hero.direction.x == 0:
		fsm.change_state(IDLE)
