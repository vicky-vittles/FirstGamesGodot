extends Area2D

signal finished_game()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("finished_game")
