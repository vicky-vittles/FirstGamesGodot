extends Node2D

signal update_placement(new_placement)
signal player_won(player)
signal game_started()
signal game_ended()

const CAR = preload("res://entities/car/Car.tscn")

onready var start_game_timer = $UI/StartGameTimer
onready var players = $Players
onready var car_spawn = $Level/CarSpawn
var car_spawn_offset = Vector2(0, 50)

var placements = {}


func _ready():
	prepare_game()

func prepare_game():
	Network.votes_to_play_again = 0
	for i in Network.players.size():
		create_player(i)
	start_game_timer.start()

func create_player(i: int):
	var id = Network.players[i]
	var car = CAR.instance()
	car.name = str(id)
	car.global_position = car_spawn.global_position + i*car_spawn_offset
	players.add_child(car)
	car.set_network_master(id)
	if id == Network.net_id:
		car.player_name = Network.my_name
	connect("game_started", car, "_on_Game_game_started")
	car.connect("update_placement", self, "_on_Car_update_placement")

func _on_StartGameTimer_timeout():
	emit_signal("game_started")

func _on_Car_update_placement():
	var cars = []
	for player in players.get_children():
		cars.append(player)
	cars.sort_custom(Globals, "sort_by_winner")
	if cars[0].current_lap >= Globals.MAX_LAPS:
		emit_signal("player_won", cars[0])
		emit_signal("game_ended")
	emit_signal("update_placement", cars)

func _on_UI_play_again():
	rpc("vote_play_again")

remotesync func vote_play_again():
	Network.votes_to_play_again += 1
	if Network.votes_to_play_again == Network.players.size():
		for player in players.get_children():
			player.queue_free()
		prepare_game()
