extends Node2D

onready var lives_tray = $LivesTray
onready var hand = $Hand
onready var high_low_panel = $HighLowPanel

var presses : int = 0
var player_model : PlayerModel


# Initialize player gui by using the given PlayerModel
func init(_model : PlayerModel):
	player_model = _model
	player_model.connect("received_card", self, "_PlayerModel_received_card")
	lives_tray.init(player_model.lives)
	lives_tray.change_name(player_model.player_name)


func _ready():
	if not is_network_master():
		pass


# Updates automatically when PlayerModel receives a card
func _PlayerModel_received_card(card):
	hand.receive_card(card)
