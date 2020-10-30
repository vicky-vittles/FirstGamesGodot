extends Node

signal update_keys(player_index, silver_keys, gold_keys)
signal update_coins(player_index, new_amount)

const MAX_SILVER_KEYS = 3
const MAX_GOLD_KEYS = 1
const MAX_COINS = 999

var silver_keys = 0
var gold_keys = 0
var coins = 0


func update_silver_keys(amount):
	silver_keys = clamp(silver_keys + amount, 0, MAX_SILVER_KEYS)
	
	emit_signal("update_keys", $"..".player_index, silver_keys, gold_keys)


func update_gold_keys(amount):
	gold_keys = clamp(gold_keys + amount, 0, MAX_GOLD_KEYS)
	
	emit_signal("update_keys", $"..".player_index, silver_keys, gold_keys)


func update_coins(amount):
	coins = clamp(coins + amount, 0, MAX_COINS)
	
	emit_signal("update_coins", $"..".player_index, coins)
