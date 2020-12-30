extends Player

onready var behavior_tree = character.get_node("BehaviorTreeRoot")

func _ready():
	behavior_tree.enable()

func get_input():
	pass
