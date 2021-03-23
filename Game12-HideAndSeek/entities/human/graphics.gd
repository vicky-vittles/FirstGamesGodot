extends Spatial

onready var human_animation_player = $human/AnimationPlayer

func play_anim(anim_name: String):
	human_animation_player.play(anim_name)
