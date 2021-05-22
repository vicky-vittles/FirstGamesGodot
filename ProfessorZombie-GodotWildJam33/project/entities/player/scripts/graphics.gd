extends Node2D

onready var player = get_parent()
onready var infect_pivot = $infect_pivot
onready var animation_player = $AnimationPlayer

func play_anim(anim):
	animation_player.play(anim)
