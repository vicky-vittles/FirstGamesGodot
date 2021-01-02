extends Node

onready var main_screens = $MainScreens

func _on_MainScreens_start_game(game):
	
	self.remove_child(main_screens)
	main_screens.call_deferred("free")
	
	self.add_child(game)
