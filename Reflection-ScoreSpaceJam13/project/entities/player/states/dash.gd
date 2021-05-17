extends State

var player
var dash_direction = Vector2()
onready var IDLE = $"../Idle"
onready var MOVE = $"../Move"
onready var DIE = $"../Die"

onready var timer = $Timer

func enter(info):
	player = fsm.actor
	dash_direction = info["dash_direction"]
	timer.wait_time = player.character_mover.DASH_TIME
	timer.start()

func process(delta):
	player.input_controller.clear_input()
	player.input_controller.get_input()

func physics_process(delta):
	player.character_mover.set_direction(dash_direction)
	player.character_mover.dash(delta)


func _on_Timer_timeout():
	if fsm.current_state == self:
		var direction = player.input_controller.input["move_direction"]
		if direction != Vector2.ZERO:
			fsm.change_state(MOVE)
		else:
			fsm.change_state(IDLE)


func _on_Player_die():
	if fsm.current_state == self:
		fsm.change_state(DIE)
