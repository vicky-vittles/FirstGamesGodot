extends Node2D

const EASE = Tween.EASE_OUT
const TRANS = Tween.TRANS_QUINT

onready var bar = $Bar
onready var tween = $Tween

func update_bar(percentage: float):
	if is_network_master():
		tween.interpolate_property(bar, "value", bar.value, percentage*100, 0.25, EASE, TRANS)
		tween.start()

func sync_bar(percentage: float):
	if not is_network_master():
		bar.value = percentage*100
