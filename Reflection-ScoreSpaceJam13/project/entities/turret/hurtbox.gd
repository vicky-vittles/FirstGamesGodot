extends Area2D

signal destroyed()

func _on_area_entered(area):
	if area.is_in_group("player"):
		emit_signal("destroyed")
