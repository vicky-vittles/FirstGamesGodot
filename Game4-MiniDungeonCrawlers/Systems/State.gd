extends Node

class_name State

export (NodePath) var fsm_path
onready var fsm = get_node(fsm_path)

func enter():
	pass

func exit():
	pass

func physics_process(_delta):
	pass
