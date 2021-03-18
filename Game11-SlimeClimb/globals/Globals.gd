extends Node

const TILE_SIZE : int = 16

func reparent_node(node: Node, new_parent: Node):
	node.get_parent().remove_child(node)
	new_parent.add_child(node)
