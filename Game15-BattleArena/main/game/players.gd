extends Node2D

const HERO = preload("res://entities/hero/Hero.tscn")

func create_players(spawn_points):
	for i in Network.players.size():
		create_player(i, spawn_points[i])

func create_player(i, spawn_point):
	var id = Network.players[i]
	var hero = HERO.instance()
	hero.name = str(id)
	hero.global_position = spawn_point.global_position
	add_child(hero)
	hero.set_network_master(id, true)
	if id == Network.net_id:
		hero.setup(Network.my_name)
