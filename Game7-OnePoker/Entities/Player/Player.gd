extends Node2D

var presses : int = 0


func _ready():
	if not is_network_master():
		pass
