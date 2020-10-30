extends Node

signal update_health(player_index, new_amount)
signal die(player_index)

export (int) var max_health = 6
onready var health = max_health

func update_health(amount):
	
	health = clamp(health + amount, 0 , max_health)
	
	if health == 0:
		emit_signal("die", $"..".player_index)
		
		health = max_health
	
	emit_signal("update_health", $"..".player_index, health)
