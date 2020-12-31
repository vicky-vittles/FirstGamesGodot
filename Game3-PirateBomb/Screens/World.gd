extends Node

onready var LEVELS = {1: preload("res://Levels/Level1.tscn"),
						2: preload("res://Levels/Level2.tscn")}

onready var main_screens = $MainScreens


func _on_MainScreens_new_game(level_id):
	start_game(level_id)


func start_game(chosen_level):
	
	remove_child(main_screens)
	main_screens.call_deferred("free")
	
	var level = LEVELS[chosen_level].instance()
	add_child(level)
