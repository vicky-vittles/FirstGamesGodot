extends CanvasLayer

const OPAQUE = Color(1, 1, 1, 1)
const TRANSPARENT = Color(1, 1, 1, 0)

onready var root_container = $MarginContainer
onready var tween = $Tween

func _ready():
	root_container.modulate = TRANSPARENT

func hide_screen():
	offset = Vector2(1300, 0)
	tween.interpolate_property(root_container, "modulate", OPAQUE, TRANSPARENT, 0.2)
	tween.start()

func show_screen():
	offset = Vector2(0, 0)
	tween.interpolate_property(root_container, "modulate", TRANSPARENT, OPAQUE, 0.2)
	tween.start()
