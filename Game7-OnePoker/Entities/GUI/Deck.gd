extends Node2D

func _ready():
	for c in get_children():
		c.disable()
