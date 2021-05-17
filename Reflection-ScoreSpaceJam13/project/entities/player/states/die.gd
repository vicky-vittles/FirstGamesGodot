extends State

var player

func enter(_info):
	player = fsm.actor
	player.animation_player.play("die")
