extends Node2D

func _ready():
	randomize()
	
	var index = randi() % 3
	
	$"../Sprite".frame = index
