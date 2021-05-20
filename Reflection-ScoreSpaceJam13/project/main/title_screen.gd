extends CanvasLayer

onready var play_button = $root/center_hbox/Play
onready var line_edit = $root/center_down/LineEdit

func _ready():
	line_edit.text = Highscore.user_name
	toggle_play_button(line_edit.text)

func toggle_play_button(new_text):
	if new_text == "":
		play_button.modulate = Color(1.0, 1.0, 1.0, 0.23)
		play_button.disabled = true
	else:
		play_button.modulate = Color(1.0, 1.0, 1.0, 1.0)
		play_button.disabled = false

func _on_LineEdit_text_changed(new_text):
	toggle_play_button(new_text)
