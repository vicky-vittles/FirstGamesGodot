extends State

const FORCE_DAMP = 0.75

onready var IDLE = $"../Idle"
onready var FALL = $"../Fall"
var is_on_iframes : bool = true
var bullet
var bullet_direction : Vector2
var hero

func enter(info):
	hero = fsm.actor
	hero.graphics.play_anim(Strings.HERO_HURT)
	bullet = info["bullet"]
	bullet_direction = bullet.global_position.direction_to(hero.global_position)
	#bullet_direction *= Vector2(-1,1)
	is_on_iframes = true
	hero.apply_impulse(bullet_direction * bullet.velocity.length() * FORCE_DAMP)

func physics_process(delta):
	hero.graphics.facing(-sign(bullet_direction.x))
	hero.apply_gravity(delta)
	hero.move(delta)
	
	if not is_on_iframes:
		if hero.is_on_floor():
			fsm.change_state(IDLE)

func animation_finished(anim_name):
	if fsm.current_state == self and anim_name == Strings.HERO_HURT:
		is_on_iframes = false
