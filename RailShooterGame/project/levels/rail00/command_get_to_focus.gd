extends ActionTrackCommand
class_name GetToFocusATCommand

export (NodePath) var focus_point_node
var focus_point

func _ready():
	focus_point = null
	if focus_point_node:
		focus_point = get_node(focus_point_node)

func trigger_entered(entity):
	if entity.has_method("get_on_focus_point"):
		entity.get_on_focus_point(focus_point)

func trigger_exited(entity):
	pass
