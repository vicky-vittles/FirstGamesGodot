extends State

var player

func enter():
	player = fsm.actor

func exit():
	pass

func process(delta):
	pass

func physics_process(delta):
	pass

func _on_Player_game_started():
	if fsm.current_state == self:
		fsm.change_state($"../Fly")
