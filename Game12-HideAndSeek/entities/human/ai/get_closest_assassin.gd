extends BehaviorTreeAction

func tick(actor, blackboard):
	var closest_assassin
	var smallest_distance = INF
	var my_pos = actor.global_transform.origin
	for assassin in actor.assassins:
		var dist = assassin.global_transform.origin.distance_to(my_pos)
		if dist < smallest_distance:
			smallest_distance = dist
			closest_assassin = assassin
	blackboard.set(Params.CLOSEST_ASSASSIN, closest_assassin)
	return SUCCESS
