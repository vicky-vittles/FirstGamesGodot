extends Node2D

onready var players = $Players
onready var level = $Level

func _ready():
	prepare_game()

func prepare_game():
	players.create_players(level.spawn_points)
