extends Area2D

var pressed = false
var was_disabled = false

func _on_Button_body_entered(body):
	if not was_disabled:
		pressed = true
		$AnimationPlayer.play("turn_on")

func _on_Button_body_exited(body):
	if not was_disabled:
		pressed = false
		$AnimationPlayer.play("turn_off")

func disable():
	pressed = true
	was_disabled = true
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("on")
