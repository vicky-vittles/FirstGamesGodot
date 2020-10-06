extends State

func enter():
	$DeathTimer.start()
	$"../../AnimatedSprite".play("dead_ground")

func exit():
	pass

func _on_DeathTimer_timeout():
	fsm.actor.get_parent().remove_child(fsm.actor)
	fsm.actor.queue_free()
