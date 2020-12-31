extends "res://Screens/BaseScreen.gd"

signal go_to_game_select()
signal go_to_options()
signal quit()


func _on_Play_pressed():
	emit_signal("go_to_game_select")


func _on_Options_pressed():
	emit_signal("go_to_options")


func _on_Quit_pressed():
	emit_signal("quit")
