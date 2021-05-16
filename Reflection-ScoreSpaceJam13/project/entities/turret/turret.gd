extends KinematicBody2D

onready var laser_spawn_pos = $LaserSpawn

func _on_Preparing_spawn_laser(pos, dir):
	get_parent().spawn_laser(pos, dir)
