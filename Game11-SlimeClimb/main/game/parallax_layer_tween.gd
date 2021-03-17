extends Tween

signal layer_finished(id, reverse)

var layer_id : int = 0
var is_reverse : bool = false

func _init(_id: int, _reverse: bool):
	layer_id = _id
	is_reverse = _reverse

func init():
	connect("tween_completed", self, "_on_ParallaxLayerTween_tween_completed")

func _on_ParallaxLayerTween_tween_completed(object, key):
	emit_signal("layer_finished", layer_id, is_reverse)
