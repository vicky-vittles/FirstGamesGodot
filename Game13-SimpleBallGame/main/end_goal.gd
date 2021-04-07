extends Area

signal win()

func _on_EndGoal_body_entered(body):
	if body.is_in_group("ball"):
		emit_signal("win")
