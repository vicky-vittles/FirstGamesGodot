extends Node

onready var resolution = Vector2(
		ProjectSettings.get_setting("display/window/size/width"),
		ProjectSettings.get_setting("display/window/size/height"))

func _ready():
	print(resolution)
