extends Position2D

func start(text: String):
	get_node("Label").text = text
	get_node("AnimationPlayer").play("float")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "float":
		queue_free()
