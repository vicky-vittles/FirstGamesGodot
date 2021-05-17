extends Node

onready var game = get_parent()
onready var turret_spawn_timer = game.get_node("TurretSpawnTimer")

const TURRET_SPAWN_TIMES = {
	15: 5.0,
	33: 4.5,
	65: 4.0,
	95: 3.0,
	125: 2.5,
	2000000000: 2}

func _physics_process(_delta):
	for key_time in TURRET_SPAWN_TIMES.keys():
		var key_value = TURRET_SPAWN_TIMES[key_time]
		if game.match_time < key_time:
			turret_spawn_timer.wait_time = key_value
			return
