extends Ship

onready var fire_range = $FireRange
onready var fire_delay = $FireDelay

var can_fire : bool = true


func _on_FireDelay_timeout():
	can_fire = true
