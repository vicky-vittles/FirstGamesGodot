extends State

var human

func enter():
	human = fsm.actor
	human.animation_player.play("die")
