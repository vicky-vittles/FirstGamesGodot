extends BehaviorTreeAction

export (String) var flag_name
export (bool) var value

func tick(actor, blackboard):
	blackboard.set(flag_name, value)
	return SUCCESS
