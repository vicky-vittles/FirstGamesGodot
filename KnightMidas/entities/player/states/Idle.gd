extends State

onready var RUN = $"../Run"
onready var JUMP = $"../Jump"

var player

func enter():
	player = fsm.actor
	player.animation_player.play("idle")

func exit():
	pass

func process(_delta):
	player.get_input()

func physics_process(delta):
	player.apply_gravity(delta)
	player.move()
	
	if player.jump_press:
		fsm.change_state(JUMP)
	
	elif player.walk_direction.x != 0:
		fsm.change_state(RUN)
