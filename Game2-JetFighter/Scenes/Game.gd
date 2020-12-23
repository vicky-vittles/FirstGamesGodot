extends Node2D

signal game_started()
signal game_won(player_victory)
signal player_took_damage()

enum GAME_STATE {START, PLAYING, END}
var current_state = GAME_STATE.START

var animated_health_p1 = 100
var animated_health_p2 = 100


func _ready():
	#$Music.play()
	$GameStartTimer.start()
	$Player1.connect("update_health", self, "_on_Player_update_health")
	$Player2.connect("update_health", self, "_on_Player_update_health")
	$Player1.connect("player_died", self, "_on_Player_player_died")
	$Player2.connect("player_died", self, "_on_Player_player_died")
	$Player1.connect("screen_exited", self, "_on_Player_screen_exited")
	$Player2.connect("screen_exited", self, "_on_Player_screen_exited")
	$Player1.connect("screen_entered", self, "_on_Player_screen_entered")
	$Player2.connect("screen_entered", self, "_on_Player_screen_entered")

func _process(delta):
	$HUD/StartCountdownLabel.text = str(ceil($GameStartTimer.time_left)) + "..."
	$HUD/HealthBar1/HealthValue1.value = animated_health_p1
	$HUD/HealthBar2/HealthValue2.value = animated_health_p2
	
	$Arrow1.look_at($Player1.global_position)
	$Arrow2.look_at($Player2.global_position)
	
	if current_state == GAME_STATE.END:
		if Input.is_action_just_pressed("reload"):
			get_tree().reload_current_scene()

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
	current_state = GAME_STATE.PLAYING
	$HUD/StartCountdownLabel.hide()
	$AsteroidSpawnTimer.start()
	emit_signal("game_started")


func _on_Player_update_health(player_index, new_amount):
	if player_index == 1:
		$HUD/HealthBar1/Tween1.interpolate_property(self, "animated_health_p1", animated_health_p1, new_amount, 0.1)
		if not $HUD/HealthBar1/Tween1.is_active():
			$HUD/HealthBar1/Tween1.start()
		$HUD/HealthBar1/AnimationPlayer.play("took_damage")
		
		emit_signal("player_took_damage")
	elif player_index == 2:
		$HUD/HealthBar2/Tween2.interpolate_property(self, "animated_health_p2", animated_health_p2, new_amount, 0.1)
		if not $HUD/HealthBar2/Tween2.is_active():
			$HUD/HealthBar2/Tween2.start()
		$HUD/HealthBar2/AnimationPlayer.play("took_damage")
		
		emit_signal("player_took_damage")


func _on_Player_player_died(player_index):
	current_state = GAME_STATE.END
	$Music.stop()
	$GameOverMusic.play()
	$HUD/VictoryLabel.show()
	if player_index == 1:
		$HUD/VictoryLabel.text = "Jogador 2 venceu! \n" + "Pressione \"R\" ou \"Start\" para recomeçar"
		emit_signal("game_won", 2)
	elif player_index == 2:
		$HUD/VictoryLabel.text = "Jogador 1 venceu! \n" + "Pressione \"R\" ou \"Start\" para recomeçar"
		emit_signal("game_won", 1)


func _on_Player_screen_exited(player_index):
	if player_index == 1:
		$Arrow1.global_position.x = clamp($Player1.global_position.x, 100, 1180)
		$Arrow1.global_position.y = clamp($Player1.global_position.y, 50, 670)
		$Arrow1.hide()
		
	elif player_index == 2:
		$Arrow2.global_position.x = clamp($Player2.global_position.x, 100, 1180)
		$Arrow2.global_position.y = clamp($Player2.global_position.y, 50, 670)
		$Arrow2.hide()


func _on_Player_screen_entered(player_index):
	if player_index == 1:
		$Arrow1.hide()
	elif player_index == 2:
		$Arrow2.hide()
