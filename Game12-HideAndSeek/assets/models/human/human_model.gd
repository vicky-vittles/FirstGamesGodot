extends Spatial

onready var man_mesh = $rig/Skeleton/Man
var single_material

func _ready():
	single_material = man_mesh.get_surface_material(0).duplicate(true) as SpatialMaterial
	man_mesh.set_surface_material(0, single_material)

func set_transparency(alpha_value: float):
	if alpha_value > 0:
		set_transparent(1.0-alpha_value)
	else:
		set_opaque()

func set_transparent(alpha_value: float):
	single_material.flags_transparent = true
	single_material.albedo_color.a = alpha_value

func set_opaque():
	single_material.flags_transparent = false
	single_material.albedo_color.a = 1.0

func change_color(new_color: Color):
	var prev_alpha = single_material.albedo_color.a
	single_material.albedo_color = new_color
	single_material.albedo_color.a = prev_alpha
