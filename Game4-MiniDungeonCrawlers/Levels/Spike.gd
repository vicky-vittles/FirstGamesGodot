extends Area2D

export (float) var offset_time

func _ready():
	$OffsetTimer.wait_time = offset_time
	$OffsetTimer.start()
	disable_shapes(true)

func disable_shapes(mode):
	$CollisionShape2D.set_deferred("disabled", mode)
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", mode)

func _on_TimerToOff_timeout():
	disable_shapes(true)
	$AnimationPlayer.play("turn_off")
	$TimerToOn.start()

func _on_TimerToOn_timeout():
	disable_shapes(false)
	$AnimationPlayer.play("turn_on")
	$TimerToOff.start()

func _on_OffsetTimer_timeout():
	$TimerToOn.start()
