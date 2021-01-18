extends Node2D

onready var this_player_pos = $ThisPlayerPos
onready var other_player_pos = $OtherPlayerPos
onready var players = $Players

const PLAYER = preload("res://Entities/Player/Player.tscn")
const OTHER_PLAYER = preload("res://Entities/Player/OtherPlayer.tscn")

var game_model


func _ready():
	# Add this player GUI scene
	var this_nuid = get_tree().get_network_unique_id()
	var this_player = PLAYER.instance()
	var this_player_init_dict = {"id":this_nuid , "name":str(this_nuid)}
	this_player.name = str(this_nuid)
	this_player.set_network_master(this_nuid)
	this_player.global_position = this_player_pos.global_position
	players.add_child(this_player)
	
	# Add other player GUI scene
	var other_player = OTHER_PLAYER.instance()
	var other_player_init_dict = {"id":Globals.other_player_id , "name":str(Globals.other_player_id)}
	other_player.name = str(Globals.other_player_id)
	other_player.set_network_master(Globals.other_player_id)
	other_player.global_position = other_player_pos.global_position
	players.add_child(other_player)
	
	# Create game model
	var players_init_dicts = [this_player_init_dict, other_player_init_dict]
	players_init_dicts.sort_custom(Globals, "sort_by_network_id")
	game_model = GameModel.new()
	game_model.init(players_init_dicts)
	
	# Link player models to each player GUI scene
	this_player.init(game_model.get_player_by_id(this_nuid))
	other_player.init(game_model.get_player_by_id(Globals.other_player_id))
	
	# Start game
	game_model.start_game()
