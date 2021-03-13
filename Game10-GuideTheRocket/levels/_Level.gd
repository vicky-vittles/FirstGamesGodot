extends Node2D

signal stage_cleared()

export (int) var level_id = 1

onready var accept_dialog = $CanvasLayer/AcceptDialog

func _ready():
	accept_dialog.get_close_button().hide()
	Globals.set_cursor_antenna()

func _on_EndZone_stage_cleared():
	Globals.set_cursor_default()
	accept_dialog.show()
	get_tree().paused = true

func _on_AcceptDialog_confirmed():
	get_tree().paused = false
	emit_signal("stage_cleared")
