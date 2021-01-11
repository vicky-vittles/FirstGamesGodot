extends Node2D

signal tile_pressed(id)

class_name Tile

const TILE_IMAGES = {
			Enums.TILE_TYPE.EMPTY: preload("res://Assets/empty.png"),
			Enums.TILE_TYPE.X: preload("res://Assets/crosses.png"),
			Enums.TILE_TYPE.O: preload("res://Assets/naught.png")}
const TILE_BUTTON_STYLES = {
			Enums.TILE_TYPE.EMPTY: preload("res://Assets/EmptyTile-ButtonStyle.tres"),
			Enums.TILE_TYPE.X: preload("res://Assets/RedTile-ButtonStyle.tres"),
			Enums.TILE_TYPE.O: preload("res://Assets/BlueTile-ButtonStyle.tres")}
const SEMI_TRANSPARENT = Color(1.0, 1.0, 1.0, 0.25)
const OPAQUE = Color(1.0, 1.0, 1.0, 1.0)

onready var button = $Button
onready var sprite = $Sprite

onready var id = int(self.name)
var board_id : int
var tile_type = Enums.TILE_TYPE.EMPTY
var is_available : bool = true


func init(_board_id : int):
	board_id = _board_id
	turn_on_off(true)


func fill_by_player(new_type):
	if not is_empty():
		return
	
	tile_type = new_type
	turn_on_off(false)
	#button.add_stylebox_override("normal", TILE_BUTTON_STYLES[tile_type])
	sprite.texture = TILE_IMAGES[tile_type]


func turn_on_off(_is_on : bool):
	if _is_on:
		button.disabled = false
		sprite.modulate = OPAQUE
		is_available = true
	else:
		button.disabled = true
		sprite.modulate = SEMI_TRANSPARENT
		is_available = false

func is_empty() -> bool:
	return tile_type == Enums.TILE_TYPE.EMPTY

func _on_Button_pressed():
	emit_signal("tile_pressed", id)
