extends Spatial

const TERRAIN_LAYER : int = 2
const TERRAIN_MASK : int = 4
onready var navigation = $Navigation
onready var qodot_map = $Navigation/NavigationMeshInstance/QodotMap
var assassin_spawn_point
var innocent_spawn_point
var hiding_spots = []

func _ready():
	for entity in qodot_map.get_children():
		if entity is StaticBody:
			entity.collision_layer = TERRAIN_LAYER
			entity.collision_mask = TERRAIN_MASK
		if entity is AssassinSpawnPoint:
			assassin_spawn_point = entity.global_transform.origin
		if entity is InnocentSpawnPoint:
			innocent_spawn_point = entity.global_transform.origin
		if entity.is_in_group("hiding_spot"):
			hiding_spots.append(entity)
