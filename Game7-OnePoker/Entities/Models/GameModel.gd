extends Node

class_name GameModel

var deck : DeckModel
var players


func init(_player_ids):
	players = []
	for _id in _player_ids:
		var new_player = PlayerModel.new()
		new_player.init(_id)
		players.append(new_player)
	deck = DeckModel.new()
	deck.init()
