extends VBoxContainer

signal change_character_type(player_index)
signal previous_character(player_index)
signal next_character(player_index)

enum PLAYER_TYPE { PLAYER = 0, CPU = 1, EMPTY = 2 }
const PLAYER_TYPE_NEXTS = [PLAYER_TYPE.CPU, PLAYER_TYPE.EMPTY, PLAYER_TYPE.PLAYER]
const PLAYER_TYPE_TEXTS = ["Player", "CPU", "Off"]

export (int) var player_index = 0
export (PLAYER_TYPE) var player_type setget set_player_type


func _on_PlayerTypeButton_pressed():
	var next_player_type = PLAYER_TYPE_NEXTS[int(player_type)]
	self.player_type = next_player_type


func _on_Left_pressed():
	pass # Replace with function body.


func _on_Right_pressed():
	pass # Replace with function body.


func set_player_type(value):
	player_type = value
	if player_type == PLAYER_TYPE.PLAYER:
		$PlayerTypeButton.text = PLAYER_TYPE_TEXTS[int(value)] + " %s" % str(player_index)
	else:
		$PlayerTypeButton.text = PLAYER_TYPE_TEXTS[int(value)]
