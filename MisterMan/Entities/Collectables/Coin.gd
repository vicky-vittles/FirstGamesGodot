extends Area2D

func _on_Coin_body_entered(body):
	$CoinCollectedSFX.play()
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite.hide()
	PlayerVariables.coins += 1


func _on_CoinCollectedSFX_finished():
	queue_free()
