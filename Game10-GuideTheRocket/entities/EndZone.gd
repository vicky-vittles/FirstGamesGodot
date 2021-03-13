extends Area2D

signal stage_cleared()

func _on_EndZone_body_entered(body):
	if body.is_in_group("rocket"):
		emit_signal("stage_cleared")
