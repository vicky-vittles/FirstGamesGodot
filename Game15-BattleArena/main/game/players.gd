extends Node2D

signal player_eliminated(player)

const HERO = preload("res://entities/hero/Hero.tscn")

onready var game = get_parent()
var players_on_screen = []

func _on_Player_respawned(player):
	var rand_index = randi()%game.level.spawn_points.size()
	player.global_position = game.level.spawn_points[rand_index].global_position
	player.reset()
	players_on_screen.append(player)

func _on_Player_dead(player):
	players_on_screen.remove(players_on_screen.find(player))

func _on_Player_eliminated(player):
	emit_signal("player_eliminated", player)


func create_players():
	var spawn_points = []
	for point in game.level.spawn_points:
		spawn_points.append(point.global_position)
	
	for i in Network.players.size():
		var rand_index = randi()%spawn_points.size()
		create_player(i, spawn_points[rand_index], game.respawn_time)
		spawn_points.remove(rand_index)
	players_on_screen = get_children()

func create_player(i, spawn_point, respawn_time):
	var id = Network.players[i]
	var hero = HERO.instance()
	hero.name = str(id)
	hero.global_position = spawn_point
	add_child(hero)
	hero.set_network_master(id, true)
	if id == Network.net_id:
		hero.setup(Network.my_name, respawn_time)
	hero.connect("died", self, "_on_Player_dead")
	hero.connect("respawned", self, "_on_Player_respawned")
	hero.connect("eliminated", self, "_on_Player_eliminated")
