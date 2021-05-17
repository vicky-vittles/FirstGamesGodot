extends CanvasLayer

onready var info_label = $root/InfoLabel

var score_text : String
var time_text : String


func _on_Game_game_started():
	get_node("root").visible = true

func _on_Game_game_over():
	get_node("root").visible = false


func _on_Game_update_time(time: float):
	var seconds = (time as int) % 60
	var minutes = int(time/60)
	if minutes < 1:
		time_text = str(seconds).pad_zeros(2)
	else:
		time_text = str(minutes) + ":" + str(seconds).pad_zeros(2)
	info_label.text = time_text


func _on_ScoreManager_update_score(score):
	score_text = str(score)
	info_label.text = time_text
