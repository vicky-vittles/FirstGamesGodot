extends Node2D

const LEVELS = {
	1: preload("res://levels/Level1.tscn"),
	2: preload("res://levels/Level2.tscn"),
	3: preload("res://levels/Level3.tscn"),
	4: preload("res://levels/Level4.tscn"),
	5: preload("res://levels/Level5.tscn")
	}

export (int) var current_level = 1

func _ready():
	load_level(current_level)

func load_level(_id: int):
	var current_level = get_node("Level")
	if current_level:
		current_level.name = "OldLevel"
		current_level.queue_free()
	
	var new_level = LEVELS[_id].instance()
	new_level.connect("stage_cleared", self, "_on_Level_stage_cleared")
	add_child(new_level)

func _on_Level_stage_cleared():
	current_level += 1
	load_level(current_level)
