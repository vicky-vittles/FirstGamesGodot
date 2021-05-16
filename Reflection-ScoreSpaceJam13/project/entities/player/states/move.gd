extends State

var player
onready var IDLE = $"../Idle"
onready var DASH = $"../Dash"
onready var SLEEP = $"../Sleep"

func enter(_info):
	player = fsm.actor

func process(delta):
	player.input_controller.clear_input()
	player.input_controller.get_input()

func physics_process(delta):
	
	var direction = player.input_controller.input["move_direction"]
	var dash_press = player.input_controller.input["dash_press"]
	if dash_press:
		fsm.change_state(DASH, {"dash_direction": direction})
	elif direction == Vector2.ZERO:
		fsm.change_state(IDLE)
	
	player.character_mover.set_direction(direction)
	player.character_mover.move(delta)


func _on_Player_die():
	if fsm.current_state == self:
		fsm.change_state(SLEEP)
