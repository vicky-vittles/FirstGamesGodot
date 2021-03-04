extends State

onready var FALL = $"../Fall"

var player

func enter():
	player = fsm.actor
	player.animation_player.play("jump")
	player.velocity.y = player.JUMP_SPEED

func exit():
	pass

func process(_delta):
	player.get_input()

func physics_process(delta):
	player.facing(player.walk_direction.x)
	player.apply_speed(player.walk_direction.x, player.SPEED)
	player.apply_gravity(delta)
	player.move()
	
	if player.velocity.y > 0:
		fsm.change_state(FALL)
