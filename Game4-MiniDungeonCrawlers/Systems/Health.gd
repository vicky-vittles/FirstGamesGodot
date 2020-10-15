extends Node

signal update_health(new_amount)
signal die()

export (int) var max_health = 3
onready var health = max_health

func take_damage(damage):
	health = health - damage
	
	if health <= 0:
		emit_signal("die")
	
	emit_signal("update_health", health)
