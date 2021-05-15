extends Node
class_name ActionTrackCommand

onready var trigger = get_parent()

func _ready():
	trigger.connect("entered", self, "trigger_entered")
	#trigger.connect("exited", self, "trigger_exited")

# Override
func trigger_entered(entity):
	pass

# Override
func trigger_exited(entity):
	pass
