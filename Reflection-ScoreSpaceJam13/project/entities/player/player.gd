extends KinematicBody2D

signal die()

onready var input_controller = $InputController
onready var character_mover = $CharacterMover
onready var dash_cooldown = $DashCooldown
onready var hitbox = $Hitbox/CollisionShape
onready var text_spawn_pos = $TextSpawnPos
onready var collision_shape = $CollisionShape
onready var animation_player = $AnimationPlayer

func die():
	emit_signal("die")
