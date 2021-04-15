extends Node

signal update_health(health)
signal health_percentage(percent)
signal healed(health_amount)
signal hurt(damage)
signal died()

export (int) var max_health = 100
onready var current_health : int = max_health

func reset_health():
	heal(max_health)

func get_health_percent() -> float:
	return float(current_health)/float(max_health)

func set_health(amount: int):
	current_health = clamp(amount, 0, max_health)
	emit_signal("update_health", current_health)
	emit_signal("health_percentage", get_health_percent())

func heal(healing_amount: int):
	current_health = clamp(current_health + healing_amount, 0, max_health)
	emit_signal("update_health", current_health)
	emit_signal("health_percentage", get_health_percent())
	emit_signal("healed", healing_amount)

func hurt(damage: int):
	current_health -= damage
	emit_signal("update_health", current_health)
	emit_signal("health_percentage", get_health_percent())
	emit_signal("hurt", damage)
	
	if current_health <= 0:
		emit_signal("died")
