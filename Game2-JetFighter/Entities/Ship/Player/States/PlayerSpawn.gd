extends State

var player

func enter():
	player = fsm.actor

func exit():
	pass

func process(_delta):
	pass

func physics_process(_delta):
	pass


func _on_Ship_game_started():
	if fsm.current_state == self:
		fsm.change_state($"../Fly")
