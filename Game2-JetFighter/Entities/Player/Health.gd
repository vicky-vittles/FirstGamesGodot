extends Node

signal update_health(new_value)
signal died()

export (int) var health = 100

func take_damage(amount):
	health -= amount
	
	if health <= 0:
		emit_signal("died")
	
	emit_signal("update_health", health)
