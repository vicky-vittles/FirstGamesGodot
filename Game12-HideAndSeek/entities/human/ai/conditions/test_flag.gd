extends BehaviorTreeCondition

export (String) var flag_name

func tick(actor, blackboard):
	if blackboard.get(flag_name):
		return SUCCESS
	return FAILURE
