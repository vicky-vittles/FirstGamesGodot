extends Node

signal update_health(new_amount)
signal die()

export (int) var max_health = 3
onready var health = max_health

func update_health(amount):
	health = health + amount
	
	if health > max_health:
		health = max_health
	
	if health <= 0:
		emit_signal("die")
	
	emit_signal("update_health", health)
