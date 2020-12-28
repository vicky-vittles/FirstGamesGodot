extends "res://Screens/BaseScreen.gd"

signal go_to_title_screen()

func set_message(message):
	$MarginContainer/VBoxContainer/Title.text = message

func _on_TitleScreen_pressed():
	emit_signal("go_to_title_screen")
