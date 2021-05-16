extends State

var player
onready var IDLE = $"../Idle"

func enter(_info):
	player = fsm.actor
	print("died")

func process(delta):
	player.input_controller.clear_input()

func physics_process(delta):
	player.character_mover.set_direction(Vector2.ZERO)
