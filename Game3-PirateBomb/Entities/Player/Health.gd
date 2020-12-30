extends Node

signal update_health(player_index, new_amount)
signal died(player_index)

export (NodePath) var actor_path
onready var actor = get_node(actor_path)

export (int) var max_health = 100
onready var health = max_health

func update_health(amount):
	health += amount
	
	if health <= 0:
		emit_signal("died", actor.player_index)
	
	emit_signal("update_health", actor.player_index, health)
