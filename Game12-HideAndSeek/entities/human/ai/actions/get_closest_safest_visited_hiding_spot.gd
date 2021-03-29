extends BehaviorTreeAction

func tick(actor, blackboard):
	var my_pos = actor.global_transform.origin
	var closest_assassin = blackboard.get(Params.CLOSEST_ASSASSIN)
	var closest_assassin_pos = closest_assassin.global_transform.origin
	var closest_spots = blackboard.get(Params.ASSASSIN_RECENT_VISITED_SPOTS)
	for spot in closest_spots:
		var spot_pos = spot.global_transform.origin
		var dist_to_assassin = my_pos.distance_to(closest_assassin_pos)
		var dist_to_spot = my_pos.distance_to(spot_pos)
		if dist_to_spot < dist_to_assassin:
			#print(spot)
			blackboard.set(Params.NEXT_CLOSEST_SAFEST_SPOT, spot)
			return SUCCESS
	blackboard.set(Params.NEXT_CLOSEST_SAFEST_SPOT, null)
	#print("null")
	return FAILURE
