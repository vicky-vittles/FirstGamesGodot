extends Node

class_name State

export (NodePath) var fsm_path
onready var fsm = get_node(fsm_path)

func enter():
	pass

func exit():
	pass

func process(delta):
	pass

func physics_process(delta):
	pass
