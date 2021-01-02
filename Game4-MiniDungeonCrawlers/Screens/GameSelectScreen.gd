extends "res://Screens/BaseScreen.gd"

signal go_to_title_screen()
signal new_game(game)

export (NodePath) var world_path
onready var world = get_node(world_path)
onready var containers = {
					1:$MarginContainer/VBoxContainer/PlayerContainers/Container1,
					2:$MarginContainer/VBoxContainer/PlayerContainers/Container2,
					3:$MarginContainer/VBoxContainer/PlayerContainers/Container3,
					4:$MarginContainer/VBoxContainer/PlayerContainers/Container4}

func _on_Back_pressed():
	emit_signal("go_to_title_screen")

func _on_Play_pressed():
	var players = []
	
	#Players 1 até 4
	for i in range(1,5):
		var model = containers[i].player
		
		if containers[i].player_type != containers[i].PLAYER_TYPE.EMPTY:
		
			var folder = str(Player.folder_names[model.character]) + "/"
			var scene_name = str(Player.folder_names[model.character]) + str(Player.gender_names_caps[model.gender])
			
			var p = load("res://Entities/Player/" + folder + scene_name + ".tscn")
			var player = p.instance()
			
			player.can_poll_input = true
			player.name = "Player" + str(i)
			player.player_index = i
			player.get_node("Objects/EquippedWeapon").show()
			
			players.append(player)
	
	var game_resource = load("res://Menus/Game.tscn")
	var game = game_resource.instance()
	game.number_of_players = players.size()
	
	for i in range(players.size()):
		game.get_node("Level/Players").add_child(players[i])
		
		var pos = game.get_node("Level/PlayerPositions/Player"+str(i+1)+"Pos").global_position
		players[i].global_position = pos
		
		
		var model = containers[i+1].player
		
		var folder = str(Player.folder_names[model.character]) + "/"
		var scene_name = str(Player.character_names[model.character]) + "_" + str(Player.gender_names[model.gender])
		
		var player_portrait = load("res://Entities/Player/" + folder + "/" + scene_name + "_face.png")
		
		game.get_node("CanvasLayer/GUI").set_player_portrait(i+1, player_portrait)
	
	emit_signal("new_game", game)
