extends WindowDialog

signal item_selected(option)

onready var option_button = $MarginContainer/VBoxContainer/OptionButton

func _ready():
	option_button.add_item(Player.PLAYER_TYPE_DESC[int(Player.PLAYER_TYPE.HUMAN)])
	option_button.add_item(Player.PLAYER_TYPE_DESC[int(Player.PLAYER_TYPE.EASY_AI)])
	option_button.add_item(Player.PLAYER_TYPE_DESC[int(Player.PLAYER_TYPE.NORMAL_AI)])
	option_button.add_item(Player.PLAYER_TYPE_DESC[int(Player.PLAYER_TYPE.PERFECT_AI)])

func _on_OptionButton_item_selected(index):
	emit_signal("item_selected", index)

func _on_CancelButton_pressed():
	self.hide()
