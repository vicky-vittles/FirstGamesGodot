extends Node2D

signal score

onready var point_sfx = $Point
const SPEED = -270

func _physics_process(delta):
	position.x += SPEED * delta
	
	if global_position.x <= -200:
		queue_free()

func _on_Wall_body_entered(body):
	if body is Player:
		if body.has_method("die"):
			body.die()

func _on_ScoreArea_body_exited(body):
	if body is Player:
		point_sfx.play()
		emit_signal("score")
