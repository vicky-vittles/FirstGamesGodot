extends State

var player
onready var MOVE = $"../move"
onready var INFECT = $"../infect"

func enter(_info):
	player = fsm.actor

func process(_delta):
	player.input_controller.clear_input()
	player.input_controller.get_input()

func physics_process(delta):
	var inputs = player.input_controller
	if player.check_infect():
		fsm.change_state(INFECT)
	elif inputs.plus_press:
		fsm.change_state(MOVE)
