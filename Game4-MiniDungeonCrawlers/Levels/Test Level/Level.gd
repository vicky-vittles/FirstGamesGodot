extends Node2D

func _ready():
	$Elements/ButtonPair.connect("activate", $Elements/SpikeGroup, "disable")
