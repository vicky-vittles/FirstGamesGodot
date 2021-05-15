extends Spatial

const TERRAIN_COLLISION_LAYER = 2
const TERRAIN_COLLISION_MASK = 4

onready var qodot_map = $QodotMap

func _ready():
	for child in qodot_map.get_children():
		if child is StaticBody:
			child.collision_layer = TERRAIN_COLLISION_LAYER
			child.collision_mask = TERRAIN_COLLISION_MASK
