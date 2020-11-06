extends Area2D

onready var click = $Click

var occupied = false

func _on_Spot_body_entered(body):
	if body.is_in_group("boxes"):
		click.play()
		occupied = true

func _on_Spot_body_exited(body):
	if body.is_in_group("boxes"):
		occupied = false
