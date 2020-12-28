extends "res://Screens/BaseScreen.gd"

signal go_to_title_screen()
signal new_vs_player_game()
signal new_vs_bot_game()

func _on_Back_pressed():
	emit_signal("go_to_title_screen")

func _on_PlayerGame_pressed():
	emit_signal("new_vs_player_game")

func _on_BotGame_pressed():
	emit_signal("new_vs_bot_game")
