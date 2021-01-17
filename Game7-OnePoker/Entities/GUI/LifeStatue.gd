extends Node2D

signal clicked(statue)

const TRANS = Tween.TRANS_LINEAR
const EASE = Tween.EASE_IN_OUT

onready var tween = $Tween


func go_to_target(_target_position : Vector2, _delay = 0.0):
	tween.interpolate_property(self, "global_position", global_position, _target_position, 0.5, TRANS, EASE, _delay)
	tween.start()


func _on_Button_pressed():
	emit_signal("clicked", self)
