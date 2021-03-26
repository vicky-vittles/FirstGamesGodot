extends BehaviorTreeAction

func _ready():
	randomize()

func tick(actor, blackboard):
	var hiding_spots = blackboard.get(Params.HIDING_SPOTS)
	var rand_index = randi() % hiding_spots.size()
	blackboard.set(Params.RANDOM_HIDING_SPOT, hiding_spots[rand_index])
	return SUCCESS
