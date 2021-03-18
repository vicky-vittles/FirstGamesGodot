extends Trigger

signal player_died()

func _on_DeathTrigger_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("player_died")
