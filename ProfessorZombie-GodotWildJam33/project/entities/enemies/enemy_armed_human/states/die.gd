extends State

var enemy

func enter(_info):
	enemy = fsm.actor
	enemy.animation_player.play("infect")

func _on_AnimationPlayer_animation_finished(anim_name):
	if fsm.current_state == self and anim_name == "infect":
		enemy.enemies.spawn_ally(enemy)
