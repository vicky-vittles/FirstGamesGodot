extends State

var turret

func enter(_info):
	turret = fsm.actor
	turret.animation_player.play("destroy")
