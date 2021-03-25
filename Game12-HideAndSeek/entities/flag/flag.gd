extends Area

export (Color) var color

onready var mesh = $MeshInstance
onready var ground = $Ground
onready var animation_player = $AnimationPlayer

func _ready():
	var mesh_material = mesh.get_surface_material(0).duplicate(true) as SpatialMaterial
	mesh_material.albedo_color = color
	mesh.set_surface_material(0, mesh_material)
	
	var ground_material = ground.get_surface_material(0).duplicate(true) as SpatialMaterial
	var prev_alpha = ground_material.albedo_color.a
	ground_material.albedo_color = color
	ground_material.albedo_color.a = prev_alpha
	ground.set_surface_material(0, ground_material)

func _on_Flag_body_entered(body):
	if body.is_in_group("innocent_human") and body.has_method("win"):
		body.win()
		animation_player.play("disable")
