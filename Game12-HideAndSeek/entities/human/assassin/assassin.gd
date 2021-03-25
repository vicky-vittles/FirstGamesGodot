extends "res://entities/human/human.gd"

onready var damage_area_shape = $DamageArea/CollisionShape
onready var weapon_animation_player = $Camera/Weapon/AnimationPlayer

func attack_start():
	damage_area_shape.disabled = false
	weapon_animation_player.play("attack")

func attack_end():
	damage_area_shape.disabled = true
