extends KinematicBody2D
class_name Collectable

const GRAVITY = 120
var velocity : Vector2

func _physics_process(delta):
	velocity += Vector2.DOWN * GRAVITY * delta
	move_and_collide(velocity * delta)

func _on_Trigger_area_entered(area):
	if area.is_in_group("hero") and area.is_in_group("collector"):
		if area.has_method("collect"):
			area.collect(self)
			rpc("destroy")

remotesync func destroy():
	queue_free()
