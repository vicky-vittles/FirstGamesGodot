extends Node2D

const ParallaxLayerTween = preload("res://main/game/parallax_layer_tween.gd")

export (Array, float) var layer_periods

var tweens = {}

func _ready():
	for i in layer_periods.size():
		var period = layer_periods[i]
		
		var normal_tween = ParallaxLayerTween.new(i, false)
		add_child(normal_tween)
		normal_tween.init()
		normal_tween.connect("layer_finished", self, "layer_tween_finished")
		setup_tween(normal_tween, i, period)
		normal_tween.name = "Tween" + str(i)
		normal_tween.start()
		
		tweens[i] = normal_tween

func setup_tween(tween, id, period):
	tween.interpolate_property(
			get_node("Layer"+str(id)), "position:y", 0, 480, period)

func layer_tween_finished(id: int, is_reverse: bool):
	var next_tween = tweens[id]
	setup_tween(next_tween, id, layer_periods[id])
	next_tween.start()
