extends "res://Screens/BaseScreen.gd"

signal go_to_game_select()
signal quit()

func _on_Play_pressed():
	emit_signal("go_to_game_select")

func _on_Quit_pressed():
	emit_signal("quit")
