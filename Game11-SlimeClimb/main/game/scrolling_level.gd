extends Node2D

export (int) var INITIAL_SCROLLING_SPEED

onready var game = $".."
onready var slime = $Slime
onready var reset_point = $"../ResetPoint"
onready var speed : int = INITIAL_SCROLLING_SPEED

var is_scrolling : bool = false

func start():
	is_scrolling = true

func _physics_process(delta):
	if is_scrolling:
		global_position.y += speed * delta
		if global_position.y >= reset_point.position.y:
			var prev_pos = slime.global_position
			global_position.y = 0
			slime.global_position = prev_pos

func _on_Slime_jump_started():
	var prev_pos = slime.global_position
	Globals.reparent_node(slime, game)
	slime.global_position = prev_pos

func _on_Slime_on_floor():
	var prev_pos = slime.global_position
	Globals.reparent_node(slime, self)
	slime.global_position = prev_pos
