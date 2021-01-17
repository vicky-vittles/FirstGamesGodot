extends Node2D

onready var this_player_pos = $ThisPlayerPos
onready var other_player_pos = $OtherPlayerPos
onready var players = $Players

const PLAYER = preload("res://Entities/Player/Player.tscn")
const OTHER_PLAYER = preload("res://Entities/Player/OtherPlayer.tscn")

var game_model


func _ready():
	# Add this player
	var this_player = PLAYER.instance()
	this_player.name = str(get_tree().get_network_unique_id())
	this_player.set_network_master(get_tree().get_network_unique_id())
	this_player.global_position = this_player_pos.global_position
	players.add_child(this_player)
	#print("Eu: " + str(get_tree().get_network_unique_id()))
	#print("Ele: " + str(Globals.other_player_id))
	
	# Add other player
	var other_player = OTHER_PLAYER.instance()
	other_player.name = str(Globals.other_player_id)
	other_player.set_network_master(Globals.other_player_id)
	other_player.global_position = other_player_pos.global_position
	players.add_child(other_player)
	
	game_model = GameModel.new()
	game_model.init([get_tree().get_network_unique_id(), Globals.other_player_id])
