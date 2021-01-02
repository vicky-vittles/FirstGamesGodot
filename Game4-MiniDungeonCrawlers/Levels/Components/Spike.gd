extends Area2D

class_name Spike

enum MODE {ALTERNATING, ALWAYS_ON}
export (MODE) var mode

export (int) var damage = 1

export (float) var offset_time
var is_enabled = true

func _ready():
	disable_shapes(true)
	
	if mode == MODE.ALTERNATING:
		$OffsetTimer.wait_time = offset_time
		$OffsetTimer.start()
	else:
		_on_TimerToOn_timeout()

func disable_shapes(_mode):
	$CollisionShape2D.set_deferred("disabled", _mode)
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", _mode)

func _on_TimerToOff_timeout():
	disable_shapes(true)
	$AnimationPlayer.play("turn_off")
	$TimerToOn.start()

func _on_TimerToOn_timeout():
	if is_enabled:
		disable_shapes(false)
		$AnimationPlayer.play("turn_on")
		
		if mode == MODE.ALTERNATING:
			$TimerToOff.start()

func _on_OffsetTimer_timeout():
	$TimerToOn.start()

func disable():
	is_enabled = false
	_on_TimerToOff_timeout()
	$TimerToOn.stop()
	$TimerToOff.stop()
