extends "res://Screens/BaseScreen.gd"

signal play_again()
signal go_to_title_screen()

func _on_PlayAgain_pressed():
	emit_signal("play_again")

func _on_TitleScreen_pressed():
	emit_signal("go_to_title_screen")
