extends Node2D

signal initialized()
signal immediate_activation()
signal spawn_copy(point, dir)

#const FADED_RED = Color("c2003a")
#const STRONG_RED = Color("ff004d")

onready var FADED_COLOR = Globals.current_palette[Globals.TURRET_WEAK_COLOR]
onready var STRONG_COLOR = Globals.current_palette[Globals.TURRET_STRONG_COLOR]

var direction : Vector2
var laser_level : int

onready var raycast = $Raycast
onready var animation_player = $AnimationPlayer


func init(dir: Vector2, _level: int, is_immediate: bool):
	direction = dir
	laser_level = _level
	if is_immediate:
		emit_signal("immediate_activation")
	else:
		emit_signal("initialized")
	#raycast.body.default_color = LASER_COLORS[laser_level]


func spawn_copy(point: Vector2, dir: Vector2, _level: int, is_immediate: bool):
	var new_level = _level-1
	if new_level > 0:
		emit_signal("spawn_copy", point, dir, new_level, is_immediate)
