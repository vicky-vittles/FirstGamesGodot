extends BehaviorTreeAction

func _ready():
	randomize()

func tick(actor, blackboard):
	# Hiding spots, excluding previous one
	var hiding_spots = blackboard.get(Params.HIDING_SPOTS)
	var prev_spot = blackboard.get(Params.PREVIOUS_HIDING_SPOT)
	if prev_spot:
		hiding_spots.remove(hiding_spots.find(prev_spot))
	
	var rand_index = randi() % hiding_spots.size()
	var hiding_spot = hiding_spots[rand_index]
	blackboard.set(Params.RANDOM_HIDING_SPOT, hiding_spot)
	blackboard.set(Params.PREVIOUS_HIDING_SPOT, hiding_spot)
	return SUCCESS
