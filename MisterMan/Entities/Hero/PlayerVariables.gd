extends Node

signal update_coins(new_amount)

var coins = 0 setget update_coins

func update_coins(new_value):
	coins = new_value
	if coins >= 100:
		coins = 0
	emit_signal("update_coins", coins)
