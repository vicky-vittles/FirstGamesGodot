extends Node2D

export (float) var respawn_time = 3.0

onready var players = $Players
onready var level = $Level

onready var collectable_spawn_timer = $CollectableSpawnTimer

func _ready():
	prepare_game()

func prepare_game():
	players.create_players()
	if Network.net_id == Network.SERVER_ID:
		collectable_spawn_timer.start()
