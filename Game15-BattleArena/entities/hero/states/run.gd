extends State

signal coyote_time()

onready var IDLE = $"../Idle"
onready var JUMP = $"../Jump"
onready var FALL = $"../Fall"
onready var HURT = $"../Hurt"
var hero

func enter(info):
	hero = fsm.actor
	hero.graphics.play_anim(Strings.HERO_RUN)

func process(delta):
	hero.get_input()

func physics_process(delta):
	hero.graphics.facing(hero.direction.x)
	hero.check_shoot()
	hero.apply_speed()
	hero.apply_gravity(delta)
	hero.move(delta)
	
	if not hero.is_on_ground():
		emit_signal("coyote_time")
		fsm.change_state(FALL)
	elif hero.jump_press:
		fsm.change_state(JUMP)
	elif hero.direction.x == 0:
		fsm.change_state(IDLE)


func get_hurt(source):
	if fsm.current_state == self:
		var bullet_direction = source.global_position.direction_to(hero.global_position)
		var info = {"bullet": source}
		fsm.change_state(HURT, info)

