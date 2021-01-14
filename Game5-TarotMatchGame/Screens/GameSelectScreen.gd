extends "res://Screens/BaseScreen.gd"

signal go_to_title_screen()
signal new_game(opponent_type)

onready var ai_dialog = $AIDifficultyDialog

var ai_type = Player.PLAYER_TYPE.HUMAN

func _on_PlayerGame_pressed():
	ai_type = Player.PLAYER_TYPE.HUMAN
	emit_signal("new_game", ai_type)

func _on_AIDifficultyDialog_item_selected(option):
	ai_type = option

func _on_AIGame_pressed():
	ai_dialog.show()

func _on_Back_pressed():
	emit_signal("go_to_title_screen")
