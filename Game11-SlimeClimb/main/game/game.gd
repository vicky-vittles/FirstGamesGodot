extends Node2D

signal game_started()
signal game_ended()
signal game_paused()
signal game_resumed()

onready var background = $Background
onready var scrolling_level = $ScrollingLevel

var slime_made_first_jump : bool = false

func _on_Slime_jump_started():
	if not slime_made_first_jump:
		emit_signal("game_started")
	slime_made_first_jump = true

func _on_PauseButton_pressed():
	var is_paused = get_tree().paused
	var now_paused = !is_paused
	get_tree().paused = now_paused
	if now_paused:
		emit_signal("game_paused")
	else:
		emit_signal("game_resumed")
