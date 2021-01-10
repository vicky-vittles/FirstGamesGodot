extends Node2D

signal tile_pressed(id)

class_name Tile

const TILE_IMAGES = {
			Enums.TILE_TYPE.EMPTY: preload("res://Assets/empty.png"),
			Enums.TILE_TYPE.X: preload("res://Assets/crosses.png"),
			Enums.TILE_TYPE.O: preload("res://Assets/naught.png")}
const SEMI_TRANSPARENT = Color(1.0, 1.0, 1.0, 0.25)
const OPAQUE = Color(1.0, 1.0, 1.0, 1.0)

onready var button = $Button
onready var sprite = $Sprite

onready var id = int(self.name)
var tile_type = Enums.TILE_TYPE.EMPTY
var tile_mode = Enums.TILE_MODE.AVAILABLE


func set_mode(new_mode):
	tile_mode = new_mode
	if new_mode == Enums.TILE_MODE.AVAILABLE:
		button.disabled = false
		sprite.modulate = OPAQUE
	else:
		button.disabled = true
		sprite.modulate = SEMI_TRANSPARENT


func fill_by_player(new_type):
	if is_occupied_by_player():
		return
	
	tile_type = new_type
	set_mode(Enums.TILE_MODE.DISABLED)
	sprite.texture = TILE_IMAGES[tile_type]


func is_empty() -> bool:
	return tile_type == Enums.TILE_TYPE.EMPTY


func is_occupied_by_player() -> bool:
	return tile_type != Enums.TILE_TYPE.EMPTY


func is_available() -> bool:
	return tile_mode == Enums.TILE_MODE.AVAILABLE


func _on_Button_pressed():
	emit_signal("tile_pressed", id)
