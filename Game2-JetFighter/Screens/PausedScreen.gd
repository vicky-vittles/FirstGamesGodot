extends "res://Screens/BaseScreen.gd"

signal go_to_empty_screen()
signal go_to_options_screen()
signal quit()

func _on_Resume_pressed():
	emit_signal("go_to_empty_screen")

func _on_Options_pressed():
	emit_signal("go_to_options_screen")

func _on_Quit_pressed():
	emit_signal("quit")
