extends Node2D

onready var LEVEL_1 = preload("res://Levels/Level1.tscn")
onready var LEVEL_2 = preload("res://Levels/Level2.tscn")

var chosen_level

func _ready():
	
	if chosen_level == 1:
		add_child(LEVEL_1.instance())
	elif chosen_level == 2:
		add_child(LEVEL_2.instance())

func change_level(level):
	chosen_level = level
