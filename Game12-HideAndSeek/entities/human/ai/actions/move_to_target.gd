extends BehaviorTreeAction

const DIST_THRESHOLD = 16

var path
var path_node : int = 0

func tick(actor, blackboard):
	var my_pos = actor.global_transform.origin
	path = blackboard.get(Params.PATH_TO_PLAYER)
	path_node = blackboard.get(Params.PATH_TO_PLAYER_CURRENT_NODE)
	var next_point = path[path_node]
	var final_pos = path[path.size()-1]
	
	actor.move_to_target(next_point)
	
	var has_reached_next_point = my_pos.distance_to(next_point) < DIST_THRESHOLD
	var has_reached_player = my_pos.distance_to(final_pos) < DIST_THRESHOLD
	
	if has_reached_next_point:
		path_node = clamp(path_node + 1, 0, path.size()-1)
	blackboard.set(Params.PATH_TO_PLAYER_CURRENT_NODE, path_node)
	if has_reached_player:
		return SUCCESS
	return RUNNING
