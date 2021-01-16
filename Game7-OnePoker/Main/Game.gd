extends Node

onready var players = $Players

const PLAYER = preload("res://Entities/Player/Player.tscn")

func _ready():
	#Add host player
	var host_player = PLAYER.instance()
	host_player.name = str(get_tree().get_network_unique_id())
	host_player.set_network_master(get_tree().get_network_unique_id())
	players.add_child(host_player)
	
	var guest_player = PLAYER.instance()
	guest_player.name = str(Globals.guest_player_id)
	guest_player.set_network_master(Globals.guest_player_id)
	players.add_child(guest_player)
	guest_player.global_position = Vector2(500, 500)
