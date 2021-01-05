extends Node2D

signal pressed(id)

class_name Cell

const OPAQUE = Color(1.0, 1.0, 1.0, 1.0)
const SEMI_TRANSPARENT = Color(1.0, 1.0, 1.0, 0.25)

onready var button = $TextureButton
onready var indication = $TextureButton/Indication

var id : int = 0
var value = Enums.CELL_TYPE.EMPTY setget set_value

func set_value(_value):
	value = _value
	button.texture_normal = Globals.CELL_SPRITES[int(value)]

func enable():
	button.set_deferred("disabled", false)
	indication.modulate = OPAQUE
	
func disable():
	button.set_deferred("disabled", true)
	indication.modulate = SEMI_TRANSPARENT

func _on_TextureButton_pressed():
	emit_signal("pressed", id)
