extends "res://Screens/BaseScreen.gd"

signal go_to_title_screen()

func _on_Back_pressed():
	emit_signal("go_to_title_screen")