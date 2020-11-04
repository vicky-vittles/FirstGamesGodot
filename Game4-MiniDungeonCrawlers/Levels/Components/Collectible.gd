extends Area2D

class_name Collectible

func disable():
	$Sprite.visible = false
	$CollisionShape2D.set_deferred("disabled", true)

func enable():
	$Sprite.visible = true
	$CollisionShape2D.set_deferred("disabled", false)

func collect():
	disable()
	$Collected.play()

func _on_Collected_finished():
	queue_free()