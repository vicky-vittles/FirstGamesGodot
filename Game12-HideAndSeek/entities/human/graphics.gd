extends Spatial

onready var human_model = $human
onready var human_animation_player = $human/AnimationPlayer

func change_color(color):
	human_model.change_color(color)

func play_anim(anim_name: String):
	human_animation_player.play(anim_name)
