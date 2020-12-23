extends State

var player

func enter():
	player = fsm.actor
	player.animation_player.play("duck_attack")

func exit():
	player.input_down = true

func process(delta):
	player.flip(player.last_direction)

func physics_process(delta):
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	if fsm.current_state == self and anim_name == "duck_attack":
		fsm.change_state($"../Duck")
