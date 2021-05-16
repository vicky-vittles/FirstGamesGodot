extends Node2D

signal initialized()
signal spawn_copy(point, dir)

var ANTICIPATION_TIME : float
var ACTIVE_TIME : float
var direction : Vector2

onready var raycast = $Raycast


func init(dir: Vector2, ant_time: float = 1.5, act_time: float = 0.25):
	direction = dir
	ANTICIPATION_TIME = ant_time
	ACTIVE_TIME = act_time
	emit_signal("initialized")


func spawn_copy(point: Vector2, dir: Vector2):
	emit_signal("spawn_copy", point, dir)
