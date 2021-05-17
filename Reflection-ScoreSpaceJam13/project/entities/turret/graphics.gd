extends Node2D

func _ready():
	get_node("graphics/Body").modulate = Globals.current_palette[Globals.TURRET_STRONG_COLOR]
