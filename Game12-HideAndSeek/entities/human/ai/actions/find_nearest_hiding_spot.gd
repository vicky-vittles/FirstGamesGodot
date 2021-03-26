extends BehaviorTreeAction

func tick(actor, blackboard):
	var hiding_spots = blackboard.get(Params.HIDING_SPOTS)
	var nearest_spot = null
	var smallest_distance = INF
	
	var my_pos = actor.global_transform.origin
	for hiding_spot in hiding_spots:
		var dist = hiding_spot.global_transform.origin.distance_to(my_pos)
		if dist < smallest_distance:
			nearest_spot = hiding_spot
			smallest_distance = dist
	blackboard.set(Params.NEAREST_HIDING_SPOT, nearest_spot)
	return SUCCESS
