extends Node2D

onready var players = $Players

func _ready():
	create_game()

func create_game():
	players.create_players()
