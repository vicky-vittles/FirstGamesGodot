extends Node2D

signal spawn_laser(pos, dir, laser_level, is_immediate)

const TURRET = preload("res://entities/turret/turret.tscn")

export (NodePath) var target_path
onready var target = get_node(target_path)


func _ready():
	spawn_turret(Vector2(1050, 630))


func spawn_turret(pos: Vector2):
	var turret = TURRET.instance()
	add_child(turret)
	turret.global_position = pos


func spawn_laser(pos, dir, laser_level, is_immediate):
	emit_signal("spawn_laser", pos, dir, laser_level, is_immediate)
