extends BehaviorTreeDecorator

class_name BehaviorTreeFailer, "res://Assets/Icons/BehaviorTree/fail.svg"

func tick(actor, blackboard):
	for c in get_children():
		var response = c.tick(actor, blackboard)
		if response == RUNNING:
			return RUNNING
		return FAILURE
