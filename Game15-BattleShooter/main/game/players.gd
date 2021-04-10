extends Node2D

const HERO = preload("res://entities/hero/Hero.tscn")

func create_players():
	for i in Network.players.size():
		create_player(i)

func create_player(i: int):
	var id = Network.players[i]
	var hero = HERO.instance()
	hero.name = str(id)
	add_child(hero)
	hero.set_network_master(id)
	if id == Network.net_id:
		hero.display_name = Network.my_name
	#connect("game_started", car, "_on_Game_game_started")
	#car.connect("update_placement", self, "_on_Car_update_placement")
