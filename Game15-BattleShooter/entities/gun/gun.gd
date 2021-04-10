extends Node2D

onready var animation_player = $AnimationPlayer

func play_look(anim_name: String):
	animation_player.play(anim_name)
