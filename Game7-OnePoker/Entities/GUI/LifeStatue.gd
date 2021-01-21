extends Node2D

signal clicked(statue)

const TRANS = Tween.TRANS_LINEAR
const EASE = Tween.EASE_IN_OUT
const ANIM_TIME = 0.4

onready var button = $Button
onready var tween = $Tween


func disable() -> void:
	button.disabled = true

func enable() -> void:
	button.disabled = false


# Go to specified target location
func go_to_target(_target_position : Vector2, _delay = 0.0):
	tween.interpolate_property(self, "global_position", global_position, _target_position, ANIM_TIME, TRANS, EASE, _delay)
	tween.start()


func _on_Button_pressed():
	emit_signal("clicked", self)
