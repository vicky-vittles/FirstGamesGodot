extends State

onready var IDLE = $"../Idle"
onready var JUMP = $"../Jump"
onready var FALL = $"../Fall"

var player

func enter():
	player = fsm.actor
	player.animation_player.play("run")

func exit():
	pass

func process(_delta):
	player.get_input()

func physics_process(delta):
	player.facing(player.walk_direction.x)
	player.apply_speed(player.walk_direction.x, player.SPEED)
	player.apply_gravity(delta)
	player.move()
	
	if player.jump_press:
		fsm.change_state(JUMP)
	
	elif not player.is_on_floor():
		fsm.change_state(FALL)
	
	elif player.walk_direction.x == 0:
		fsm.change_state(IDLE)
