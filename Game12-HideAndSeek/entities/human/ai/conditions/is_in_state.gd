extends BehaviorTreeCondition

export (String) var state

func tick(actor, blackboard):
	if actor.fsm.current_state.name == state:
		return SUCCESS
	return FAILURE
