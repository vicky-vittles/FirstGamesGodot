extends Spatial

const TERRAIN_LAYER : int = 2
const TERRAIN_MASK : int = 4
onready var navigation = $Navigation
onready var qodot_map = $Navigation/NavigationMeshInstance/QodotMap

func _ready():
	for terrain in qodot_map.get_children():
		if terrain is StaticBody:
			terrain.collision_layer = TERRAIN_LAYER
			terrain.collision_mask = TERRAIN_MASK
