extends BehaviorTreeAction

const NOT_Y_AXIS = Vector3(1,0,1)

var path

func tick(actor, blackboard):
	var my_pos = actor.global_transform.origin
	var player_pos = blackboard.get(Params.TARGET_POS)
	path = actor.nav.get_simple_path(my_pos, player_pos, false)
	if path.size() > 0:
		print("calculated path")
		blackboard.set(Params.PATH_TO_TARGET, path)
		blackboard.set(Params.PATH_TO_TARGET_CURRENT_NODE, 0)
	return SUCCESS
