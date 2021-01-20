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
	
	# Create game model if itself is a server
	if this_nuid == Globals.SERVER_ID:
		var players_init_dicts = [this_player_init_dict, other_player_init_dict]
		players_init_dicts.sort_custom(Globals, "sort_by_network_id")
		game_model = GameModel.new()
		game_model.init(players_init_dicts)
		
		# Start game
		game_model.start_game()
		
		# Link player models to each player GUI scene
		var encoded_game_model = encode_game_model()
		rpc("set_encoded_game_model", encoded_game_model)
		set_game_model(game_model)


func encode_game_model():
	var _encoded = {}
	var cards = []
	for i in game_model.deck.cards.size():
		var _card_model = game_model.deck.cards[i]
		cards.append([_card_model.card_suit, _card_model.card_value])
	
	var players_to_add = []
	for i in game_model.players.size():
		var _player = game_model.players[i]
		players_to_add.append([_player.id, _player.player_name])
	
	_encoded["deck"] = cards
	_encoded["players"] = players_to_add
	
	return _encoded


remote func set_encoded_game_model(_encoded_game_model) -> void:
	var _game_model = GameModel.new()
	
	var _deck_model = DeckModel.new()
	var deck = []
	for i in _encoded_game_model["deck"].size():
		var _card_model = CardModel.new()
		_card_model.init(_encoded_game_model["deck"][i][0], _encoded_game_model["deck"][i][1])
		deck.append(_card_model)
	_deck_model.cards = deck
	
	var players_to_add = []
	for i in _encoded_game_model["players"].size():
		var _player_model = PlayerModel.new()
		_player_model.init(_encoded_game_model["players"][i][0], _encoded_game_model["players"][i][1])
		players_to_add.append(_player_model)
	
	_game_model.deck = _deck_model
	_game_model.players = players_to_add
	_game_model.last_winning_player_id = Globals.INVALID_PLAYER_ID
	
	set_game_model(_game_model)


func set_game_model(_game_model) -> void:
	game_model = _game_model
	
	var this_nuid = get_tree().get_network_unique_id()
	var this_player = get_player(this_nuid)
	this_player.init(game_model.get_player_by_id(this_nuid))
	
	var other_player = get_player(Globals.other_player_id)
	other_player.init(game_model.get_player_by_id(Globals.other_player_id))


func get_player(_player_id : int):
	for p in players.get_children():
		if p.name == str(_player_id):
			return p
