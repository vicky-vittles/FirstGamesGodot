extends Node

onready var players = $Players

const PLAYER = preload("res://Entities/Player/Player.tscn")

var game_model


func _ready():
	#Add host player
	var this_player = PLAYER.instance()
	this_player.name = str(get_tree().get_network_unique_id())
	this_player.set_network_master(get_tree().get_network_unique_id())
	players.add_child(this_player)
	#print("Eu: " + str(get_tree().get_network_unique_id()))
	#print("Ele: " + str(Globals.other_player_id))
	
	var other_player = PLAYER.instance()
	other_player.name = str(Globals.other_player_id)
	other_player.set_network_master(Globals.other_player_id)
	players.add_child(other_player)
	other_player.global_position = Vector2(500, 500)
	
	game_model = GameModel.new()
	game_model.init([get_tree().get_network_unique_id(), Globals.other_player_id])
