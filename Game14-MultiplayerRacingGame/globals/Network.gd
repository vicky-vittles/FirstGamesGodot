extends Node

const NETWORK_PORT = 4242
const MAX_PLAYERS = 5

var players = []
var net_id
var my_name : String

var votes_to_play_again : int = 0

func add_player(id: int):
	players.append(id)
