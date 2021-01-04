extends Node2D

signal activate()

var red_button
var blue_button
var has_activated = false

func _ready():
	red_button = get_node("Red")
	blue_button = get_node("Blue")
	
	red_button.other_button = blue_button
	blue_button.other_button = red_button

func _physics_process(delta):
	if red_button.pressed and blue_button.pressed and not has_activated:
		red_button.disable()
		blue_button.disable()
		
		has_activated = true
		
		emit_signal("activate")
