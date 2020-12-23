extends State

var player

func enter():
	player = fsm.actor
	player.animation_player.play("attack")

func exit():
	pass

func process(delta):
	player.flip(player.last_direction)

func physics_process(delta):
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	if fsm.current_state == self and anim_name == "attack":
		fsm.change_state($"../Idle")
