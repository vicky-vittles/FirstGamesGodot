extends State

const MOUSE_MIN_DIST_THRESHOLD = 32

var player
onready var IDLE = $"../idle"
onready var INFECT = $"../infect"

func enter(_info):
	player = fsm.actor

func process(_delta):
	player.input_controller.clear_input()
	player.input_controller.get_input()

func physics_process(delta):
	check_move(delta)
	
	var inputs = player.input_controller
	if player.check_infect():
		fsm.change_state(INFECT)
	elif not inputs.plus_hold:
		fsm.change_state(IDLE)

func check_move(delta):
	var mouse_pos = player.get_global_mouse_position()
	var dist = player.global_position.distance_to(mouse_pos)
	var dir = player.global_position.direction_to(mouse_pos)
	if dist > MOUSE_MIN_DIST_THRESHOLD:
		player.look_at(mouse_pos)
		player.character_mover.set_direction(dir)
		player.character_mover.move(delta)
