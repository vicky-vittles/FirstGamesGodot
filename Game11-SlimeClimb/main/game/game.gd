extends Node2D

signal game_started()
signal game_ended()

onready var background = $Background
onready var scrolling_level = $ScrollingLevel

var slime_made_first_jump : bool = false

func _on_Slime_jump_started():
	if not slime_made_first_jump:
		emit_signal("game_started")
	slime_made_first_jump = true
