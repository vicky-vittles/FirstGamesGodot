extends State

onready var WALK = $"../Walk"
var hero

func enter():
	hero = fsm.actor

func process(delta):
	hero.get_input()

func physics_process(delta):
	var angle_to_mouse = hero.get_angle_to_mouse()
	hero.graphics.play_idle(angle_to_mouse)
	hero.graphics.play_weapon(angle_to_mouse)
	
	if hero.shoot:
		hero.shoot_gun()
	
	if hero.direction != Vector2.ZERO:
		fsm.change_state(WALK)
