extends BehaviorTreeAction

func tick(actor, blackboard):
	var all_recently_visited_hiding_spots = []
	for assassin in actor.assassins:
		for hiding_spot in assassin.recent_visited_hiding_spots:
			if not all_recently_visited_hiding_spots.has(hiding_spot):
				var my_pos = actor.global_transform.origin
				var hiding_spot_pos = hiding_spot.global_transform.origin
				var dist_to_me = my_pos.distance_to(hiding_spot_pos)
				all_recently_visited_hiding_spots.append([hiding_spot, dist_to_me])
	all_recently_visited_hiding_spots.sort_custom(Funcs, "sort_by_distance")
	
	var result = []
	for i in all_recently_visited_hiding_spots.size():
		result.append(all_recently_visited_hiding_spots[i][0])
	blackboard.set(Params.ASSASSIN_RECENT_VISITED_SPOTS, result)
	return SUCCESS
