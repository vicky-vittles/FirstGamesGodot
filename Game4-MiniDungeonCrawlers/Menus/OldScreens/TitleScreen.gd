extends MarginContainer

func _on_Play_pressed():
	
	var mainNode = get_parent()
	
	var title_screen = self
	mainNode.remove_child(title_screen)
	title_screen.call_deferred("free")
	
	var game_resource = load("res://Menus/CharacterSelectScreen.tscn")
	var game = game_resource.instance()
	mainNode.add_child(game)

func _on_Quit_pressed():
	get_tree().quit()
