extends State

onready var RUN = $"../Run"
onready var JUMP = $"../Jump"
onready var HURT = $"../Hurt"
onready var DEAD = $"../Dead"
var hero

func enter(info):
	hero = fsm.actor
	hero.graphics.play_anim(Strings.HERO_IDLE)

func process(delta):
	hero.get_input()

func physics_process(delta):
	hero.graphics.facing(hero.direction.x)
	hero.check_shoot()
	hero.apply_speed()
	hero.apply_gravity(delta)
	hero.move(delta)
	
	if hero.jump_press:
		fsm.change_state(JUMP)
	elif hero.direction.x != 0:
		fsm.change_state(RUN)


func get_hurt(source):
	if fsm.current_state == self:
		var info = {"bullet": source}
		fsm.change_state(HURT, info)

func die(_player):
	if fsm.current_state == self:
		fsm.change_state(DEAD)
