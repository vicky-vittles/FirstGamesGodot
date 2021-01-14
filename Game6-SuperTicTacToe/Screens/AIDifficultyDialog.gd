extends WindowDialog

signal item_selected(option)

onready var option_button = $MarginContainer/VBoxContainer/OptionButton

func _ready():
	option_button.add_item(Enums.PLAYER_TYPE_DESC[int(Enums.PLAYER_TYPE.HUMAN)])
	option_button.add_item(Enums.PLAYER_TYPE_DESC[int(Enums.PLAYER_TYPE.AI)])

func _on_OptionButton_item_selected(index):
	emit_signal("item_selected", index)

func _on_CancelButton_pressed():
	self.hide()
