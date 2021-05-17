extends CanvasLayer

onready var scores_label = $root/scores

func _on_Game_game_results(score, highscore):
	scores_label.text = "Current Score: %s\nBest Score: %s" % [score, highscore]

func _on_PlayAgain_pressed():
	get_tree().reload_current_scene()
