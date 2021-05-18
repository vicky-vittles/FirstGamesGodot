extends State

signal clear_points()

const DISTANCE_THRESHOLD = 4

var player
var path_to_follow = []
onready var IDLE = $"../idle"

func enter(info):
	player = fsm.actor
	path_to_follow = info["path_to_follow"]

func process(delta):
	player.input_controller.clear_input()
	player.input_controller.get_input()

func physics_process(delta):
	
	if player.input_controller.minus_press:
		emit_signal("clear_points")
		fsm.change_state(IDLE)
	
	if path_to_follow.size() > 0:
		var next_point = path_to_follow.front()
		var dir = player.global_position.direction_to(next_point)
		
		player.character_mover.set_direction(dir)
		player.character_mover.move(delta)
		player.look_at(next_point)
		
		var dist = player.global_position.distance_to(next_point)
		if dist < DISTANCE_THRESHOLD:
			path_to_follow.pop_front()
