extends Node2D

signal update_level(level_id)

onready var game = $".."
onready var level_manager = $LevelManager
onready var slime = $Slime
onready var reset_point = $"../ResetPoint"
onready var speed : int = Enums.get_scroll_speed(level_manager.current_level)

var is_scrolling : bool = false

func start():
	is_scrolling = true
	emit_signal("update_level", level_manager.current_level)

func _physics_process(delta):
	if is_scrolling:
		global_position.y += speed * delta
		if global_position.y >= reset_point.position.y:
			reset_level()

func reset_level():
	var prev_pos = slime.global_position
	var next_level = level_manager.current_level + 1
	global_position.y = 0
	slime.global_position = prev_pos
	speed = Enums.get_scroll_speed(next_level)
	emit_signal("update_level", next_level)

func _on_Slime_jump_started():
	var prev_pos = slime.global_position
	Globals.reparent_node(slime, game)
	slime.global_position = prev_pos

func _on_Slime_on_floor():
	var prev_pos = slime.global_position
	Globals.reparent_node(slime, self)
	slime.global_position = prev_pos
