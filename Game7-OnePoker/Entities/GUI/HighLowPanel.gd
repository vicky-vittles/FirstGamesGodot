extends Node2D

onready var label = $Label


func set_message(_high : int, _low : int):
	label.text = "High: " + str(_high) + "    Low: " + str(_low)
