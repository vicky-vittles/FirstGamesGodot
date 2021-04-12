extends State

const VELOCITY_DAMP = 0.35

onready var FALL = $"../Fall"
onready var HURT = $"../Hurt"
var hero

func enter(info):
	hero = fsm.actor
	hero.graphics.play_anim(Strings.HERO_JUMP)
	hero.velocity.y = hero.JUMP_SPEED

func process(delta):
	hero.get_input()

func physics_process(delta):
	hero.graphics.facing(hero.direction.x)
	hero.check_shoot()
	hero.apply_speed()
	hero.apply_gravity(delta)
	hero.move(delta)
	
	if hero.jump_released:
		hero.velocity.y *= VELOCITY_DAMP
	
	if hero.velocity.y > 0:
		fsm.change_state(FALL)


func get_hurt(source):
	if fsm.current_state == self:
		var bullet_direction = source.global_position.direction_to(hero.global_position)
		var info = {"bullet": source}
		fsm.change_state(HURT, info)

