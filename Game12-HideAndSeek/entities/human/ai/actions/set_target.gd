extends BehaviorTreeAction

export (String) var param_name

func tick(actor, blackboard):
	var entity = blackboard.get(param_name)
	blackboard.set(Params.TARGET, entity)
	blackboard.set(Params.TARGET_POS, entity.global_transform.origin)
	return SUCCESS
