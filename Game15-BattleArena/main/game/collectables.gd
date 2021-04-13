extends Node2D

const GUN_COLLECTABLE = preload("res://entities/items/GunCollectable.tscn")
onready var game = get_parent()
var spawn_area

func _ready():
	randomize()

func spawn():
	var new_collectable = GUN_COLLECTABLE.instance()
	add_child(new_collectable)
	spawn_area = game.level.collectable_spawn_area
	new_collectable.global_position = spawn_area.get_random_point()
	
	var info = {"pos": new_collectable.global_position}
	rpc("sync_spawn", info)

remote func sync_spawn(info):
	var new_collectable = GUN_COLLECTABLE.instance()
	add_child(new_collectable)
	new_collectable.global_position = info["pos"]
