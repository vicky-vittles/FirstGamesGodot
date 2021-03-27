extends BehaviorTreeAction

const DIST_THRESHOLD = 1

var path
var path_node : int = 0


func tick(actor, blackboard):
	var my_pos = actor.global_transform.origin
	path = blackboard.get(Params.PATH_TO_TARGET)
	path_node = blackboard.get(Params.PATH_TO_TARGET_CURRENT_NODE)
	var next_point = path[path_node]
	var final_pos = path[path.size()-1]
	
	var has_reached_next_point = my_pos.distance_to(next_point) < DIST_THRESHOLD
	var has_reached_target = my_pos.distance_to(final_pos) < DIST_THRESHOLD
	
	if has_reached_next_point:
		path_node = int(clamp(path_node + 1, 0, path.size()-1))
	blackboard.set(Params.PATH_TO_TARGET_CURRENT_NODE, path_node)
	
	actor.move_to_target(path[path_node])
	
	if has_reached_target:
		return SUCCESS
	return RUNNING


func is_near_stopping_point(actor, _path, _path_node):
#	if path == null or path.size() == 0 or is_near_stopping_point(actor, path, path_node):
#		actor.move_direction = Vector3.ZERO
#		print("parei")
#		return SUCCESS
	var point = _path[_path_node]
	return (_path.size() < 2 and actor.global_transform.origin.distance_to(point) < DIST_THRESHOLD)
