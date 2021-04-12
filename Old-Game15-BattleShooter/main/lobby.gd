extends Control

signal start_game()

onready var name_input = $root/vbox/hbox/VBoxContainer/host_options/name_input
onready var ip_input = $root/vbox/hbox/VBoxContainer/join_options/ip_input
onready var host_button = $root/vbox/hbox/VBoxContainer/host_options/Host
onready var join_button = $root/vbox/hbox/VBoxContainer/join_options/Join


func _ready():
	disable_net_options()
	get_tree().connect("network_peer_connected", self, "_player_connected")


func _player_connected(id):
	Network.add_player(id)
	if Network.players.size() > 0:
		start_game()

func start_game():
	Network.net_id = get_tree().get_network_unique_id()
	Network.my_name = name_input.text
	Network.add_player(Network.net_id)
	emit_signal("start_game")


func _on_Host_pressed():
	disable_net_options()
	var net = NetworkedMultiplayerENet.new()
	net.create_server(Network.NETWORK_PORT, Network.NETWORK_PLAYERS)
	get_tree().network_peer = net

func _on_Join_pressed():
	disable_net_options()
	var net = NetworkedMultiplayerENet.new()
	net.create_client(ip_input.text, Network.NETWORK_PORT)
	get_tree().network_peer = net


func _on_name_input_text_changed(new_text):
	if new_text == "":
		disable_net_options()
	else:
		enable_net_options()

func enable_net_options():
	host_button.disabled = false
	join_button.disabled = false

func disable_net_options():
	host_button.disabled = true
	join_button.disabled = true
