extends State

const MOUSE_POS_THRESHOLD = 16

var player
onready var IDLE = $"../idle"
onready var MOVE = $"../move"

var mouse_path = []

func enter(_info):
	player = fsm.actor
	mouse_path = [player.get_global_mouse_position()]

func process(_delta):
	player.input_controller.clear_input()
	player.input_controller.get_input()

func physics_process(delta):
	var inputs = player.input_controller
	
	fill_path_points()
	
	if inputs.minus_press:
		fsm.change_state(IDLE)
	elif not inputs.plus_hold:
		fsm.change_state(MOVE, {"path_to_follow": mouse_path})

func fill_path_points():
	var mouse_pos = player.get_global_mouse_position()
	var dist = mouse_pos.distance_to(mouse_path.back())
	if dist > MOUSE_POS_THRESHOLD:
		mouse_path.append(mouse_pos)
		player.add_point(mouse_pos)
