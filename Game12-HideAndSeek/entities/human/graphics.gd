extends Spatial

onready var human_model = $human
onready var human_animation_player = $human/AnimationPlayer

var transparent_alpha_value : float = 1.0

func stop_anim():
	human_animation_player.stop()

func reset_anim():
	human_animation_player.play(Globals.HUMAN_IDLE_ANIM)

func set_transparency(alpha_value: float):
	human_model.set_transparency(alpha_value)

func change_color(color):
	human_model.change_color(color)

func play_anim(anim_name: String):
	human_animation_player.play(anim_name)
