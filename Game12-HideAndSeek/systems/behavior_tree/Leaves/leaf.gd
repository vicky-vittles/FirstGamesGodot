extends BehaviorTreeNode

class_name BehaviorTreeLeaf, "res://assets/icons/behavior_tree/action.svg"

func _ready():
	if self.get_child_count() != 0:
		print("BehaviorTree Error: Leaf %s should not have children" % self.name)
