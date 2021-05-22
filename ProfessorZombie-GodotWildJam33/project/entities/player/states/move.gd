extends State

const MOUSE_MIN_DIST_THRESHOLD = 32

var player
onready var INFECT = $"../infect"

var target_dir : Vector2
var last_target_dir : Vector2

func enter(_info):
	player = fsm.actor
	player.graphics.play_anim("walk")

func process(_delta):
	player.input_controller.clear_input()
	player.input_controller.get_input()

func physics_process(delta):
	check_move(delta)
	
	var inputs = player.input_controller
	if player.check_infect():
		fsm.change_state(INFECT, {"infect_collider": player.infect_collider})

func check_move(delta):
	var mouse_pos = player.get_global_mouse_position()
	var mouse_dir = player.global_position.direction_to(mouse_pos)
	
	target_dir = lerp(target_dir, mouse_dir , player.stats.MOVE_MANEUVERABILITY)
	
	var dist = player.global_position.distance_to(mouse_pos)
	if dist < MOUSE_MIN_DIST_THRESHOLD:
		target_dir = last_target_dir
	else:
		last_target_dir = target_dir
	player.look_at(player.global_position + target_dir)
	player.character_mover.set_direction(target_dir)
	player.character_mover.move(delta)
