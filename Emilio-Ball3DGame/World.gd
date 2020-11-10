extends Spatial

onready var victory_label = $CanvasLayer/VictoryLabel

func _on_GoalTrigger_body_entered(body):
	if body.is_in_group("player"):
		victory_label.show()
