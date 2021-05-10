extends "res://entities/trigger/trigger.gd"

export (NodePath) var dolly_path_node
var dolly_path

func _ready():
	assert(dolly_path_node)
	dolly_path = get_node(dolly_path_node)

func activate(entity):
	if entity.has_method("get_on_dolly_path"):
		entity.get_on_dolly_path(dolly_path)
