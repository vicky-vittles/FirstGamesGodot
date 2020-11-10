extends CanvasLayer

func show_message(text):
	$Message.text = text
	$AnimationPlayer.play("show_message")

func hide():
	$ScoreBox.hide()

func show():
	$ScoreBox.show()

func update_score(new_score):
	$ScoreBox/HBoxContainer/Score.text = str(new_score)
