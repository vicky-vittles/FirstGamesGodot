extends BehaviorTreeRoot
class_name Brain

export (NodePath) var game_path
onready var game = get_node(game_path)

func _ready():
	blackboard.set(Params.GAME, game)

func _physics_process(delta):
	blackboard.set(Params.DELTA, delta)
