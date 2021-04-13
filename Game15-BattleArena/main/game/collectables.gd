extends Node2D

const GUN_COLLECTABLE = preload("res://entities/items/GunCollectable.tscn")
onready var spawn_area = $"../CollectibleSpawnArea"

func _ready():
	randomize()

func spawn():
	var new_collectable = GUN_COLLECTABLE.instance()
	add_child(new_collectable)
	new_collectable.global_position = spawn_area.get_random_point()
	
	var info = {"pos": new_collectable.global_position}
	rpc("sync_spawn", info)

remote func sync_spawn(info):
	var new_collectable = GUN_COLLECTABLE.instance()
	add_child(new_collectable)
	new_collectable.global_position = info["pos"]
