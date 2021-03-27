extends BehaviorTreeAction

export (Array, String) var tests_to_make

func tick(actor, blackboard):
	for assassin in actor.vision_of_assassins.keys():
		var info = actor.vision_of_assassins[assassin]
		var result = true
		for test in tests_to_make:
			result = result and info[test]
		if result:
			blackboard.set(Params.FOUND_BY_ASSASSIN, true)
			return SUCCESS
	blackboard.set(Params.FOUND_BY_ASSASSIN, false)
	return SUCCESS
