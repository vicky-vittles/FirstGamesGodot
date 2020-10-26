extends Node2D

func _ready():
	$MultiTargetCamera.add_target($Players/Player1)
	$MultiTargetCamera.add_target($Players/Player2)
	
	$Elements/ButtonPair.connect("activate", $Elements/SpikeGroup, "disable")
