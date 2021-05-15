extends ActionTrackCommand
class_name GetToPathATCommand

export (NodePath) var dolly_path_node
onready var dolly_path = get_node(dolly_path_node)

func trigger_entered(entity):
	if entity.has_method("get_on_dolly_path"):
		entity.get_on_dolly_path(dolly_path)

func trigger_exited(entity):
	pass
