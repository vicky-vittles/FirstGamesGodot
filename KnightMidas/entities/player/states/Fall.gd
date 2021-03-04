extends State

onready var IDLE = $"../Idle"

var player

func enter():
	player = fsm.actor
	player.animation_player.play("fall")

func exit():
	pass

func process(_delta):
	player.get_input()

func physics_process(delta):
	player.facing(player.walk_direction.x)
	player.apply_speed(player.walk_direction.x, player.SPEED)
	player.apply_gravity(delta)
	player.move()
	
	if player.is_on_floor():
		fsm.change_state(IDLE)
