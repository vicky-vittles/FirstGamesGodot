extends Node2D

var display_name : String setget set_display_name

onready var name_label = $Name

func set_display_name(value):
	display_name = value
	name_label.text = display_name
