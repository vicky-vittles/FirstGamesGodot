extends State

var player
onready var PLAN = $"../plan"

func enter(_info):
	player = fsm.actor

func process(_delta):
	player.input_controller.clear_input()
	player.input_controller.get_input()

func physics_process(_delta):
	var inputs = player.input_controller
	if inputs.is_mouse_colliding and inputs.plus_press:
		fsm.change_state(PLAN)
