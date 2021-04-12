extends Node2D

onready var animation_player = $AnimationPlayer

func facing(dir: int):
	if dir == 1:
		scale.x = 1
	elif dir == -1:
		scale.x = -1

func play_anim(anim_name):
	animation_player.play(anim_name)

func stop_anim():
	animation_player.stop()
