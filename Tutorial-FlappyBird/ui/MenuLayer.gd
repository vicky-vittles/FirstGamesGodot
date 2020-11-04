extends CanvasLayer

signal start_game()

onready var tween = $Tween
onready var start_message = $StartMenu/StartMessage
onready var score_label = $GameOverMenu/VBoxContainer/ScoreLabel
onready var highscore_label = $GameOverMenu/VBoxContainer/HighscoreLabel
onready var game_over_menu = $GameOverMenu
var game_started = false

func _input(event):
	if event.is_action_pressed("flap") and not game_started:
		game_started = true
		tween.interpolate_property(start_message, "modulate:a", 1, 0, 0.5)
		tween.start()
		
		emit_signal("start_game")

func init_game_over_menu(score, highscore):
	score_label.text = "Score: " + str(score)
	highscore_label.text = "Best: " + str(highscore)
	game_over_menu.visible = true

func _on_RestartButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
