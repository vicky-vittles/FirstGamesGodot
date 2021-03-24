extends "res://entities/human/human.gd"

onready var weapon_animation_player = $Camera/Weapon/AnimationPlayer

func attack():
	weapon_animation_player.play("attack")
