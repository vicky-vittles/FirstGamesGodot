extends "res://Screens/BaseScreen.gd"

signal go_to_title_screen()
signal new_game(opponent_type_chosen)

onready var ai_dialog = $AIDifficultyDialog
var opponent_type_chosen = Enums.PLAYER_TYPE.HUMAN

func _on_Play_pressed():
	emit_signal("new_game", opponent_type_chosen)

func _on_Options_pressed():
	ai_dialog.show()

func _on_AIDifficultyDialog_item_selected(option):
	opponent_type_chosen = option

func _on_Back_pressed():
	emit_signal("go_to_title_screen")
