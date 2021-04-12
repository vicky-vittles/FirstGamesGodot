extends Node

signal update_health(health)
signal healed(health_amount)
signal hurt(damage)
signal died()

export (int) var max_health

onready var current_health : int = max_health

func heal(healing_amount: int):
	current_health = clamp(current_health + healing_amount, 0, max_health)
	emit_signal("update_health", current_health)
	emit_signal("healed", healing_amount)

func hurt(damage: int):
	current_health -= damage
	emit_signal("update_health", current_health)
	emit_signal("hurt", damage)
	
	if current_health <= 0:
		emit_signal("died")
