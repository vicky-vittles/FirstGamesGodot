extends BehaviorTreeNode

class_name BehaviorTreeDecorator, "res://assets/icons/behavior_tree/category_decorator.svg"

func _ready():
	if self.get_child_count() != 1:
		print("BehaviorTree Error: Decorator %s should only have one child" % self.name)
