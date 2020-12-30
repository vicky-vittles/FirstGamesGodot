extends BehaviorTreeNode

class_name BehaviorTreeComposite, "res://Assets/Icons/BehaviorTree/category_composite.svg"

func _ready():
	if self.get_child_count() < 1:
		print("BehaviorTree Error: Composite node %s should have at least one child" % self.name)
