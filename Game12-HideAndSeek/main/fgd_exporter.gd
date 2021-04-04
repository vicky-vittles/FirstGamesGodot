extends Node

export (bool) var enabled = false

const PGD = preload("res://addons/qodot/game_definitions/fgd/qodot_fgd.tres")

func _ready():
	if enabled:
		PGD.set_export_file()
