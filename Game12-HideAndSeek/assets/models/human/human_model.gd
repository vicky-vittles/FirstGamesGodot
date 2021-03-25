extends Spatial

onready var man_mesh = $rig/Skeleton/Man

func set_transparent(alpha_value: float):
	var material = man_mesh.mesh.surface_get_material(0) as SpatialMaterial
	material.flags_transparent = true
	material.albedo_color.a = alpha_value

func set_opaque():
	var material = man_mesh.mesh.surface_get_material(0) as SpatialMaterial
	material.flags_transparent = false
	material.albedo_color.a = 1.0

func change_color(new_color: Color):
	var new_material = man_mesh.mesh.surface_get_material(0).duplicate(true)
	var prev_alpha = new_material.albedo_color.a
	new_material.albedo_color = new_color
	new_material.albedo_color.a = prev_alpha
	man_mesh.material_override = new_material
