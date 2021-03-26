extends BehaviorTreeAction

func tick(actor, blackboard):
	var game = blackboard.get(Params.GAME)
	for human in game.humans:
		if human.is_player:
			blackboard.set(Params.PLAYER, human)
			blackboard.set(Params.PLAYER_POS, human.global_transform.origin)
			return SUCCESS
	return FAILURE
