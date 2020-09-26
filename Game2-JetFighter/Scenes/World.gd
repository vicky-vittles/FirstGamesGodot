extends Node2D

signal game_started()


func _ready():
	$GameStartTimer.start()

func _process(delta):
	$StartCountdownLabel.text = str(ceil($GameStartTimer.time_left)) + "..."

func _on_AsteroidSpawnTimer_timeout():
	randomize()
	
	$AsteroidSpawn/AsteroidSpawnLocation.offset = randi()
	var rand_int = randi()%4 + 1
	
	var asteroid = load("res://Entities/Asteroids/Asteroid-"+str(rand_int)+".tscn").instance()
	$Asteroids.add_child(asteroid)
	
	var direction = $AsteroidSpawn/AsteroidSpawnLocation.rotation + PI / 2
	
	asteroid.position = $AsteroidSpawn/AsteroidSpawnLocation.position
	
	direction += rand_range(-PI/4, PI/4)
	asteroid.rotation = direction
	asteroid.direction = Vector2(cos(direction), sin(direction))


func _on_GameStartTimer_timeout():
	$StartCountdownLabel.hide()
	$AsteroidSpawnTimer.start()
	emit_signal("game_started")
