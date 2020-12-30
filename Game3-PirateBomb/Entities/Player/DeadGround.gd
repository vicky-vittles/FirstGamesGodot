extends State

var player

func enter():
	player = fsm.actor
	$DeathTimer.start()
	player.animated_sprite.play("dead_ground")

func _on_DeathTimer_timeout():
	player.get_parent().remove_child(player)
	player.queue_free()
