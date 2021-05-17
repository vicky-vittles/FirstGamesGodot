extends Node2D

func _ready():
	get_node("Sprite").modulate = Globals.current_palette[Globals.PLAYER_COLOR]
