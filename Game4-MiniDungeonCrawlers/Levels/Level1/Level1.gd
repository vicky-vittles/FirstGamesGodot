extends Node2D

onready var game = $".."

func _ready():
	$Music.play()
	
	for c in $Players.get_children():
		$MultiTargetCamera.add_target(c)
	
	if $Players.get_child_count() > 1:
		$MultiTargetCamera.current = true
	else:
		var single_player_camera = $SinglePlayerCamera
		single_player_camera.current = true
		single_player_camera.get_parent().remove_child(single_player_camera)
		$Players/Player1.add_child(single_player_camera)
	
	$Elements/ButtonPair.connect("activate", $Elements/SpikeGroup, "disable")
	$Elements/ButtonPair2.connect("activate", $Elements/SpikeGroup4, "disable")
