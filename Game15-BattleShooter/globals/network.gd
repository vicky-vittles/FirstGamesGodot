extends Node

const NETWORK_PORT = 4242
const NETWORK_PLAYERS = 10

var net_id : int
var my_name : String
var players = []

func add_player(id):
	players.append(id)
	players.sort()
