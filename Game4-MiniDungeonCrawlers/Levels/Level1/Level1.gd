extends Node2D

func _ready():
	$Music.play()
	
	$MultiTargetCamera.add_target($Players/Player1)
	$MultiTargetCamera.add_target($Players/Player2)
	
	$Elements/ButtonPair.connect("activate", $Elements/SpikeGroup, "disable")
	$Elements/ButtonPair2.connect("activate", $Elements/SpikeGroup4, "disable")
