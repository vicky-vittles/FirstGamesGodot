extends Ship

onready var fire_range = $FireRange
onready var fire_delay = $FireDelay

var can_fire : bool = true


func _on_FireDelay_timeout():
	can_fire = true


func _on_Game_game_won(player_victory):
	pass # Replace with function body.
