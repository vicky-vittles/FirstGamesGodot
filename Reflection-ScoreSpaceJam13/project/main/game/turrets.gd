extends Node2D

signal spawn_laser(pos, dir, laser_level, is_immediate)
signal turret_destroyed()

const TURRET = preload("res://entities/turret/turret.tscn")

export (NodePath) var target_path
onready var turret_spawn_area = get_node("../TurretSpawnArea")
onready var target = get_node(target_path)


func _ready():
	spawn_turret()


func turret_destroyed(turret):
	emit_signal("turret_destroyed")


func turn_off_turrets():
	for child in get_children():
		if child.has_method("turn_off"):
			child.turn_off()


func spawn_turret():
	turret_spawn_area.get_node("follow").offset = randi()
	var rand_pos = turret_spawn_area.get_node("follow").position
	var turret = TURRET.instance()
	add_child(turret)
	turret.global_position = rand_pos


func spawn_laser(pos, dir, laser_level, is_immediate):
	emit_signal("spawn_laser", pos, dir, laser_level, is_immediate)
