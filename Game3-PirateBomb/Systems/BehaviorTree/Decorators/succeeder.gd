extends BehaviorTreeDecorator

class_name BehaviorTreeSucceeder, "res://Assets/Icons/BehaviorTree/succeed.svg"

func tick(actor, blackboard):
	for c in get_children():
		var response = c.tick(actor, blackboard)
		if response == RUNNING:
			return RUNNING
		return SUCCESS
