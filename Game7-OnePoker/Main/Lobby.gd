extends Node2D

const GAME = preload("res://Main/Game.tscn")

onready var host_button = $HostButton
onready var join_button = $JoinButton


func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")

func _player_connected(id):
	print("Player connected to server!")
	Globals.other_player_id = id
	var game = GAME.instance()
	get_tree().get_root().add_child(game)
	hide()


func _on_HostButton_pressed():
	create_server()
	host_button.disabled = true
	join_button.hide()
	
func create_server() -> void:
	print("Hosting network")
	var peer = NetworkedMultiplayerENet.new()
	var result = peer.create_server(Settings.SERVER_PORT, Settings.NUMBER_OF_PLAYERS)
	if result != OK:
		print("Failed to host game")
		return
	get_tree().network_peer = peer


func _on_JoinButton_pressed():
	create_client()
	host_button.hide()
	join_button.disabled = true

func create_client() -> void:
	print("Joining network")
	var host = NetworkedMultiplayerENet.new()
	host.create_client(Settings.SERVER_ID, Settings.SERVER_PORT)
	get_tree().network_peer = host
