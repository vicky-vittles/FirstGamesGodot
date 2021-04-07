extends Area2D

export (int) var id = 0

func _on_body_entered(body):
	if body.is_in_group("car") and body.has_method("completed_checkpoint"):
		body.completed_checkpoint(id)
