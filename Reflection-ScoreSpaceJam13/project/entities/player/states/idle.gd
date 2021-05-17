extends State

var player
onready var MOVE = $"../Move"
onready var DIE = $"../Die"

func enter(_info):
	player = fsm.actor

func process(delta):
	player.input_controller.clear_input()
	player.input_controller.get_input()

func physics_process(delta):
	
	var direction = player.input_controller.input["move_direction"]
	if direction != Vector2.ZERO:
		fsm.change_state(MOVE)
	
	player.character_mover.set_direction(direction)
	player.character_mover.move(delta)


func _on_Player_die():
	if fsm.current_state == self:
		fsm.change_state(DIE)
