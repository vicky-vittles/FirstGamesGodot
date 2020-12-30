extends BehaviorTreeAction

func tick(actor, blackboard):
	actor.left = true
	return SUCCESS
