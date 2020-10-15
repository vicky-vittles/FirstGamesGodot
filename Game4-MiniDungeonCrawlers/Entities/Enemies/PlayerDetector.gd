extends Area2D

var marked_player

func _on_PlayerDetector_body_entered(body):
	if body.is_in_group("player"):
		marked_player = body

func _on_PlayerDetector_body_exited(body):
	if body.is_in_group("player"):
		marked_player = null
