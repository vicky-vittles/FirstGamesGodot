extends Node2D

signal update_time(time)
signal game_started()
signal game_over()
signal game_results(score, highscore)

onready var score_manager = $ScoreManager
onready var player = $Player
onready var turret_spawn_area = $TurretSpawnArea

var match_time : float
var match_is_on : bool

func start_game():
	match_is_on = true
	get_node("TurretSpawnTimer").start()
	emit_signal("game_started")

func _physics_process(delta):
	if match_is_on:
		match_time += delta
		emit_signal("update_time", match_time)

func player_died():
	match_is_on = false
	emit_signal("game_over")
	emit_signal("game_results", score_manager.score, score_manager.highscore)
