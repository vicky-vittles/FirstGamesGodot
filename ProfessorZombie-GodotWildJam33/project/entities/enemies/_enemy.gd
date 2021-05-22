extends KinematicBody2D

signal infected()

onready var enemies = get_parent()
onready var behind_position = $BehindPosition
onready var collision_shape = $CollisionShape
onready var animation_player = $AnimationPlayer

func disable_enemy():
	collision_shape.disabled = true

func infect():
	emit_signal("infected")
