extends BehaviorTreeAction

const NOT_Y_AXIS = Vector3(1,0,1)
export (String) var param_name

var path

func tick(actor, blackboard):
	var my_pos = actor.global_transform.origin
	var player_pos = blackboard.get(param_name)
	path = actor.nav.get_simple_path(my_pos, player_pos * NOT_Y_AXIS, true)
	if path.size() > 0:
		blackboard.set(Params.PATH_TO_PLAYER, path)
		blackboard.set(Params.PATH_TO_PLAYER_CURRENT_NODE, 0)
