extends StaticBody2D

class_name Door

func open():
	$DoorShape.set_deferred("disabled", true)
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite.play("open")
	$Open.play()
