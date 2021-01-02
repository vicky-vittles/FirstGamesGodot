extends VBoxContainer

const OPAQUE = Color(1, 1, 1, 1)
const TRANSPARENT = Color(1, 1, 1, 0)

onready var player = $Control/Player

enum PLAYER_TYPE { PLAYER = 0, CPU = 1, EMPTY = 2 }
const PLAYER_TYPE_NEXTS = [PLAYER_TYPE.CPU, PLAYER_TYPE.EMPTY, PLAYER_TYPE.PLAYER]
const PLAYER_TYPE_TEXTS = ["Player", "CPU", "Off"]

export (int) var player_index = 0
export (PLAYER_TYPE) var player_type setget set_player_type


func _on_PlayerTypeButton_pressed():
	var next_player_type = PLAYER_TYPE_NEXTS[int(player_type)]
	self.player_type = next_player_type


func _on_Left_pressed():
	set_player(-1)


func _on_Right_pressed():
	set_player(1)


func set_player_type(value):
	player_type = value
	if player_type == PLAYER_TYPE.PLAYER:
		$PlayerTypeButton.text = PLAYER_TYPE_TEXTS[int(value)] + " %s" % str(player_index)
	else:
		$PlayerTypeButton.text = PLAYER_TYPE_TEXTS[int(value)]
	
	if player_type == PLAYER_TYPE.EMPTY:
		$Control/Player.modulate = TRANSPARENT
	else:
		$Control/Player.modulate = OPAQUE


func set_player(direction):
	
	if direction == 1:
		if player.gender == Player.GENDER.MALE:
			player.gender = Player.GENDER.FEMALE
		else:
			player.gender = Player.GENDER.MALE
			if player.character < Player.CHARACTERS.size()-1:
				player.character = min(player.character+1, Player.CHARACTERS.size()-1)
			else:
				player.character = 0
	
	elif direction == -1:
		if player.gender == Player.GENDER.FEMALE:
			player.gender = Player.GENDER.MALE
		else:
			player.gender = Player.GENDER.FEMALE
			if player.character > 0:
				player.character = max(player.character-1, 0)
			else:
				player.character = Player.CHARACTERS.size()-1
	
	player.set_sprite()
