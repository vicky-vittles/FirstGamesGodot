extends Node

signal update_health(player_index, new_amount)
signal died(player_index)

export (int) var max_health = 100
onready var health = max_health

func update_health(amount):
	health += amount
	
	if health <= 0:
		emit_signal("died", $"..".player_index)
	
	emit_signal("update_health", $"..".player_index, health)
