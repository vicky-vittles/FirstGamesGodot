extends Node2D

func _ready():
	$Elements/ButtonPair.connect("activate", $Doors/Door2, "open")
