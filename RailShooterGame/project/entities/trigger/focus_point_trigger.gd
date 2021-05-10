extends "res://entities/trigger/trigger.gd"

export (NodePath) var focus_point_node
var focus_point

func _ready():
	if focus_point_node:
		focus_point = get_node(focus_point_node)

func activate(entity):
	if entity.has_method("get_on_focus_point"):
		entity.get_on_focus_point(focus_point)
