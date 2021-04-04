extends Node

var current_screen

func _ready():
	for screen in get_children():
		screen.hide_screen()
	change_screen(get_child(0).name)

func change_screen(new_screen_name):
	var new_screen = get_node(new_screen_name)
	
	if current_screen:
		current_screen.hide_screen()
		current_screen.exit()
	
	current_screen = new_screen
	current_screen.show_screen()
	current_screen.enter()
