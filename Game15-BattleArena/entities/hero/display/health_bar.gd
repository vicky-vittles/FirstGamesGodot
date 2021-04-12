extends Node2D

const EASE = Tween.EASE_OUT
const TRANS = Tween.TRANS_QUINT

onready var bar = $Bar
onready var tween = $Tween

func update_bar(percentage: float):
	tween.interpolate_property(bar, "value", bar.value, percentage*100, 0.25, EASE, TRANS)
	tween.start()
