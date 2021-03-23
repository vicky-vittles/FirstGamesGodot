extends Node2D

signal game_started()
signal game_ended()
signal game_paused()
signal game_resumed()

onready var background = $Background
onready var scrolling_level = $ScrollingLevel
onready var death_sfx = $Sounds/Death

var is_game_over : bool = false
var slime_made_first_jump : bool = false

func _input(event):
	if is_game_over:
		if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
			reset_game()

func reset_game():
	get_tree().reload_current_scene()

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

func _on_DeathTrigger_player_died():
	if not is_game_over:
		death_sfx.play()
		emit_signal("game_ended")
	is_game_over = true
