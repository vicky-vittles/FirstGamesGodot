extends Control

const CHAT_COLORS = {
			"me": Color("#008dff"),
			"enemy": Color("#ff8900")}

onready var chat_log = $VBoxContainer/RichTextLabel
onready var input_label = $VBoxContainer/Input/Label
onready var input_field = $VBoxContainer/Input/LineEdit


func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			input_field.grab_focus()
		elif event.pressed and event.scancode == KEY_ESCAPE:
			input_field.release_focus()
