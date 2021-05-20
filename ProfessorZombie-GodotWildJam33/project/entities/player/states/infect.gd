extends State

var player

func enter(info):
	player = fsm.actor
	player.graphics.play_infect(info["infect_collider"])

func process(_delta):
	pass
