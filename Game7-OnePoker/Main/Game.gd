extends Node2D

const CARD_MODEL_SCENE = preload("res://Entities/Models/CardModel.tscn")
const DECK_MODEL_SCENE = preload("res://Entities/Models/DeckModel.tscn")
const PLAYER_MODEL_SCENE = preload("res://Entities/Models/PlayerModel.tscn")
const GAME_MODEL_SCENE = preload("res://Entities/Models/GameModel.tscn")

onready var open_cards = $OpenCards
onready var lives_tray = $LivesTray
onready var this_player_pos = $ThisPlayerPos
onready var other_player_pos = $OtherPlayerPos
onready var players = $Players

const PLAYER = preload("res://Entities/Player/Player.tscn")
const OTHER_PLAYER = preload("res://Entities/Player/OtherPlayer.tscn")

var game_model


# Create Player Views, and if server, start Game
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
	
	# Create game model if itself is a server
	if this_nuid == Globals.SERVER_ID:
		var players_init_dicts = [this_player_init_dict, other_player_init_dict]
		players_init_dicts.sort_custom(Globals, "sort_by_network_id")
		game_model = GAME_MODEL_SCENE.instance()
		add_child(game_model)
		game_model.init(players_init_dicts)
		
		# Start game
		game_model.start_game()
		
		# Link player models to each player GUI scene
		var encoded_game_model = encode_game_model()
		rpc("set_encoded_game_model", encoded_game_model)
		set_game_model(game_model)


# Get Player scene GUI using network id
func get_player(_player_id : int):
	for p in players.get_children():
		if p.name == str(_player_id):
			return p


# Called by the server to encode the game state and send to the clients
func encode_game_model():
	var _encoded = {}
	var cards = []
	for i in game_model.deck.cards.size():
		var _card_model = game_model.deck.cards[i]
		cards.append([_card_model.card_suit, _card_model.card_value])
	
	var players_to_add = []
	for i in game_model.players.get_child_count():
		var _player = game_model.players.get_child(i)
		var _player_hand = []
		for j in _player.hand.size():
			_player_hand.append([_player.hand[j].card_suit, _player.hand[j].card_value])
		players_to_add.append([_player.id, _player.player_name, _player_hand])
	
	_encoded["game_stage"] = game_model.game_stage
	_encoded["deck"] = cards
	_encoded["players"] = players_to_add
	
	return _encoded


# Method that the server calls for the clients to execute and update their game model
remote func set_encoded_game_model(_encoded_game_model) -> void:
	var _game_model = GAME_MODEL_SCENE.instance()
	
	var _deck_model = DECK_MODEL_SCENE.instance()
	for i in _encoded_game_model["deck"].size():
		var _card_model = CARD_MODEL_SCENE.instance()
		_card_model.init(_encoded_game_model["deck"][i][0], _encoded_game_model["deck"][i][1])
		_deck_model.cards.add_child(_card_model)
	
	var players_to_add = []
	for i in _encoded_game_model["players"].size():
		var _player_model = PLAYER_MODEL_SCENE.instance()
		_player_model.init(_encoded_game_model["players"][i][0], _encoded_game_model["players"][i][1])
		for j in _encoded_game_model["players"][i][2].size():
			var card_to_add = CARD_MODEL_SCENE.instance()
			card_to_add.init(_encoded_game_model["players"][i][2][j][0], _encoded_game_model["players"][i][2][j][1])
			_player_model.hand.append(card_to_add)
			_
		players_to_add.append(_player_model)
	
	_game_model.game_stage = _encoded_game_model["game_stage"]
	_game_model.deck = _deck_model
	_game_model.players = players_to_add
	_game_model.last_winning_player_id = Globals.INVALID_PLAYER_ID
	
	set_game_model(_game_model)


# Called by all clients to set the final game model variable and start the game
func set_game_model(_game_model) -> void:
	game_model = _game_model
#	for i in game_model.deck.cards.size():
#		print(game_model.deck.cards[i])
	
	# Connect player view signal to game view
	var this_nuid = get_tree().get_network_unique_id()
	var this_player = get_player(this_nuid)
	this_player.init(game_model.get_player_by_id(this_nuid))
	this_player.connect("chosen_card", self, "_on_Player_chose_card")
	game_model.get_player_by_id(this_nuid).sync_signals()
	
	var other_player = get_player(Globals.other_player_id)
	other_player.init(game_model.get_player_by_id(Globals.other_player_id))
	game_model.get_player_by_id(Globals.other_player_id).sync_signals()
	
	# Connect game model signals to game gui
	game_model.connect("player_chose_card", self, "_on_GameModel_player_chose_card")
	game_model.connect("change_game_stage", self, "_on_GameModel_change_game_stage")


# Player GUI chose card signal
func _on_Player_chose_card(player_id, chosen_card):
	var player_model = game_model.get_player_by_id(player_id)
	game_model.player_chose_card(player_id, chosen_card.model)


# Update when Game Model updates the players' chosen cards
func _on_GameModel_player_chose_card(player_id, card_model):
	# Get player GUI scene with player_id
	var this_nuid = get_tree().get_network_unique_id()
	var is_equal_this_nuid = (player_id == this_nuid)
	var player_gui
	if is_equal_this_nuid:
		player_gui = get_player(this_nuid)
	else:
		player_gui = get_player(Globals.other_player_id)
	
	# Get Card GUI scene, and calculate its final position of animation
	var card_gui = player_gui.hand.get_card_by_model(card_model.card_suit, card_model.card_value)
	var previous_pos = card_gui.global_position
	var card_destiny_pos
	if is_equal_this_nuid:
		card_destiny_pos = open_cards.this_player_pos
	else:
		card_destiny_pos = open_cards.other_player_pos
	
	# Reparent card (to open cards), and start its animation
	card_gui.get_parent().remove_child(card_gui)
	open_cards.add_child(card_gui)
	card_gui.global_position = previous_pos
	card_gui.go_to_target(card_destiny_pos.global_position)
	card_gui.close()
	
	# If this client has chosen its cards, enable next game stage buttons
	if is_equal_this_nuid:
		player_gui.hand.disable_cards()
	player_gui.lives_tray.enable_statues()


# Update when Game Model updates its game stage
func _on_GameModel_change_game_stage(game_stage):
	pass
