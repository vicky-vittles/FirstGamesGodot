extends Spatial

onready var man_mesh = $rig/Skeleton/Man

func change_color(new_color: Color):
	var new_material = man_mesh.mesh.surface_get_material(0).duplicate(true)
	new_material.albedo_color = new_color
	man_mesh.material_override = new_material
