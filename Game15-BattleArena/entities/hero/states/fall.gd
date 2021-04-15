extends State

onready var IDLE = $"../Idle"
onready var RUN = $"../Run"
onready var JUMP = $"../Jump"
onready var HURT = $"../Hurt"
onready var DEAD = $"../Dead"
onready var coyote_timer = $CoyoteTimer
var hero

func enter(info):
	hero = fsm.actor

func exit():
	coyote_timer.stop()

func process(delta):
	hero.get_input()

func physics_process(delta):
	hero.graphics.facing(hero.direction.x)
	hero.check_shoot()
	hero.apply_speed()
	hero.apply_gravity(delta)
	hero.move(delta)
	
	if not coyote_timer.is_stopped():
		if hero.jump_press:
			fsm.change_state(JUMP)
	
	if hero.is_on_ground():
		if hero.direction.x != 0:
			fsm.change_state(RUN)
		else:
			fsm.change_state(IDLE)


func coyote_time():
	coyote_timer.start()

func get_hurt(source):
	if fsm.current_state == self:
		var bullet_direction = source.global_position.direction_to(hero.global_position)
		var info = {"bullet": source}
		fsm.change_state(HURT, info)

func die(_player):
	if fsm.current_state == self:
		fsm.change_state(DEAD)
