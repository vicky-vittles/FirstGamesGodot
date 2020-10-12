extends State

func enter():
	fsm.actor.get_node("AnimationPlayer").play("hit")

func exit():
	print("saiu de Hurt")

func physics_process(delta):
	pass
