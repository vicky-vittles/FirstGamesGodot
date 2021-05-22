extends Node2D

signal spawn_ally(pos)

func spawn_ally(enemy):
	var pos = enemy.global_position
	emit_signal("spawn_ally", pos)
