extends BehaviorTreeAction

export (Vector3) var direction

func tick(actor, blackboard):
	actor.move_direction = direction
	return SUCCESS
