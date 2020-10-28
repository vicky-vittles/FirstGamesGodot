extends MarginContainer

func _on_Right1_pressed():
	change_player(1, 1)

func _on_Left1_pressed():
	change_player(1, -1)

func _on_Right2_pressed():
	change_player(2, 1)

func _on_Left2_pressed():
	change_player(2, -1)

func change_player(player_index, direction):
	var player = get_node("VBoxContainer/Players/Player" + str(player_index) + "/Control/Player")
	
	if direction == 1:
		if player.gender == Player.GENDER.MALE:
			player.gender = Player.GENDER.FEMALE
		else:
			player.character = min(player.character+1, Player.CHARACTERS.size()-1)
			player.gender = Player.GENDER.MALE
	
	elif direction == -1:
		if player.gender == Player.GENDER.FEMALE:
			player.gender = Player.GENDER.MALE
		else:
			player.character = max(player.character-1, 0)
			player.gender = Player.GENDER.FEMALE
	
	player.set_sprite()


func _on_Play_pressed():
	
	var mainNode = get_parent()
	
	var players = []
	for i in range(1,3):
		var model = get_node("VBoxContainer/Players/Player" + str(i) + "/Control/Player")
		
		var folder = str(Player.folder_names[model.character]) + "/"
		var scene_name = str(Player.folder_names[model.character]) + str(Player.gender_names_caps[model.gender])
		
		var p = load("res://Entities/Player/" + folder + scene_name + ".tscn")
		var player = p.instance()
		
		player.can_poll_input = true
		player.name = "Player" + str(i)
		player.player_index = i
		player.get_node("EquippedWeapon").show()
		
		players.append(player)
	
	var character_screen = self
	mainNode.remove_child(character_screen)
	character_screen.call_deferred("free")
	
	var game_resource = load("res://Screens/Game.tscn")
	var game = game_resource.instance()
	
	for i in range(players.size()):
		game.get_node("Level/Players").add_child(players[i])
		
		var pos = game.get_node("Level/Players/Player"+str(i+1)+"Pos").global_position
		players[i].global_position = pos
		
		
		var model = get_node("VBoxContainer/Players/Player" + str(i+1) + "/Control/Player")
		
		var folder = str(Player.folder_names[model.character]) + "/"
		var scene_name = str(Player.character_names[model.character]) + "_" + str(Player.gender_names[model.gender])
		
		var player_portrait = load("res://Entities/Player/" + folder + "/" + scene_name + "_face.png")
		
		game.get_node("CanvasLayer/GUI").set_player_portrait(i+1, player_portrait)
	
	mainNode.add_child(game)
