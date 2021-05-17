extends KinematicBody2D

signal turn_off()

onready var aim = $Aim
onready var laser_spawn_pos = $LaserSpawn
onready var animation_player = $AnimationPlayer

func turn_off():
	emit_signal("turn_off")

func spawn_laser(pos, dir, laser_level, is_immediate):
	get_parent().spawn_laser(pos, dir, laser_level, is_immediate)

func destroyed():
	get_parent().turret_destroyed(self)
