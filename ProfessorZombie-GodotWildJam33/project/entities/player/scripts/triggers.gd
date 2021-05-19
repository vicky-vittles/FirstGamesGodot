extends Node2D

export (NodePath) var body_path
onready var body = get_node(body_path)
onready var infect_ray = $InfectRay

func _ready():
	infect_ray.add_exception(body)
