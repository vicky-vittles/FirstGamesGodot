extends Node

onready var game = $Game

func _on_Game_game_ended(player_points):
	game.queue_free()
	
	for i in player_points.size():
		print(str(i) + ": " + str(player_points[i]))
