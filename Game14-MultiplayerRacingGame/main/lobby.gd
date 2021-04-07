extends MarginContainer

signal start_game()

onready var host_button = $vbox/hbox/Items/host_option/Host
onready var join_button = $vbox/hbox/Items/join_option/Join
onready var ip_address_input = $vbox/hbox/Items/join_option/ip_address
onready var name_input = $vbox/hbox/Items/host_option/name_edit


func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")

func _on_Host_pressed():
	host_button.disabled = true
	join_button.disabled = true
	
	var net = NetworkedMultiplayerENet.new()
	net.create_server(Network.NETWORK_PORT, Network.MAX_PLAYERS)
	get_tree().network_peer = net

func _on_Join_pressed():
	host_button.disabled = true
	join_button.disabled = true
	
	var net = NetworkedMultiplayerENet.new()
	net.create_client(ip_address_input.text, Network.NETWORK_PORT)
	get_tree().network_peer = net


func _player_connected(id: int):
	Network.add_player(id)
	if Network.players.size() > 0:
		start_game()

func start_game():
	Network.net_id = get_tree().get_network_unique_id()
	Network.my_name = name_input.text
	Network.add_player(Network.net_id)
	Network.players.sort()
	emit_signal("start_game")


func _on_name_edit_text_changed(new_text):
	if new_text == "":
		host_button.disabled = true
		join_button.disabled = true
		ip_address_input.editable = false
	else:
		host_button.disabled = false
		join_button.disabled = false
		ip_address_input.editable = true
