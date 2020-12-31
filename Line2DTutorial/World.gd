extends Node2D

onready var line = $Line2D
onready var sprite = $Sprite
onready var nav = $Navigation2D

func _unhandled_input(event):
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return
	
	var path = nav.get_simple_path(sprite.global_position, event.global_position)
	line.points = path
