extends BehaviorTreeRoot
class_name Brain

func init_blackboard(game):
	blackboard.set(Params.GAME, game)
	blackboard.set(Params.HUMANS, game.humans)
	blackboard.set(Params.HIDING_SPOTS, game.map.hiding_spots)

func _physics_process(delta):
	blackboard.set(Params.DELTA, delta)
