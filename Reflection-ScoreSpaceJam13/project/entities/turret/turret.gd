extends KinematicBody2D

onready var aim = $Aim
onready var laser_spawn_pos = $LaserSpawn
onready var animation_player = $AnimationPlayer

func spawn_laser(pos, dir, laser_level, is_immediate):
	get_parent().spawn_laser(pos, dir, laser_level, is_immediate)
