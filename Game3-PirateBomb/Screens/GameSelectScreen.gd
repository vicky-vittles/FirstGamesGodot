extends "res://Screens/BaseScreen.gd"

signal go_to_title_screen()
signal new_game(level_id)

func _on_Back_pressed():
	emit_signal("go_to_title_screen")

func _on_Stage1_pressed():
	emit_signal("new_game", 1)

func _on_Stage2_pressed():
	emit_signal("new_game", 2)
