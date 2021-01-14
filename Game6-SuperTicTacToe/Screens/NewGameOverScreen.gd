extends Node

onready var label = $CanvasLayer/MarginContainer/VBoxContainer/Label

func set_message(message):
	label.text = message

func _on_Button_pressed():
	get_tree().reload_current_scene()
