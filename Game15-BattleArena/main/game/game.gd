extends Node2D

onready var players = $Players
onready var level = $Level

onready var collectable_spawn_timer = $CollectableSpawnTimer

func _ready():
	prepare_game()

func prepare_game():
	players.create_players(level.spawn_points)
	if Network.net_id == Network.SERVER_ID:
		collectable_spawn_timer.start()
