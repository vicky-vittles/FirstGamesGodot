extends BehaviorTreeDecorator

class_name BehaviorTreeSucceeder, "res://assets/icons/behavior_tree/succeed.svg"

func tick(actor, blackboard):
	for c in get_children():
		var response = c.tick(actor, blackboard)
		if response == RUNNING:
			return RUNNING
		return SUCCESS
