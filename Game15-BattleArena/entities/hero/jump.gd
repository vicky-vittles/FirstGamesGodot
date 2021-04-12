extends State

const VELOCITY_DAMP = 0.35

onready var FALL = $"../Fall"
var hero

func enter():
	hero = fsm.actor
	hero.graphics.play_anim(Strings.JUMP)
	hero.velocity.y = hero.JUMP_SPEED

func process(delta):
	hero.get_input()

func physics_process(delta):
	hero.graphics.facing(hero.direction.x)
	hero.apply_speed()
	hero.apply_gravity(delta)
	hero.move(delta)
	
	if hero.jump_released:
		hero.velocity.y *= VELOCITY_DAMP
	
	if hero.velocity.y > 0:
		fsm.change_state(FALL)
