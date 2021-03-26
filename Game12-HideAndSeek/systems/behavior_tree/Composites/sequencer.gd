extends BehaviorTreeComposite

class_name BehaviorTreeSequencer, "res://assets/icons/behavior_tree/sequencer.svg"

func tick(actor, blackboard):
	for c in get_children():
		var response = c.tick(actor, blackboard)
		
		if response != SUCCESS:
			return response
	
	return SUCCESS
