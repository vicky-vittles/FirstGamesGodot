extends Node2D

signal game_started()
signal game_won(player_victory)
signal player_took_damage()

onready var arrow_1 = $Arrow1
onready var arrow_2 = $Arrow2
onready var player_1 = $Player1
onready var player_2 = $Player2

enum GAME_STATE {START, PLAYING, END}
var current_state = GAME_STATE.START
var m

var animated_health_p1 = 100
var animated_health_p2 = 100


func _ready():
	#Settings.change_music_slider(0)
	#Settings.change_sound_slider(0)
	$Music.play()
	
	$GameStartTimer.start()
	player_1.connect("update_health", self, "_on_Player_update_health")
	player_2.connect("update_health", self, "_on_Player_update_health")
	player_1.connect("player_died", self, "_on_Player_player_died")
	player_2.connect("player_died", self, "_on_Player_player_died")
	player_1.connect("screen_exited", self, "_on_Player_screen_exited")
	player_2.connect("screen_exited", self, "_on_Player_screen_exited")
	player_1.connect("screen_entered", self, "_on_Player_screen_entered")
	player_2.connect("screen_entered", self, "_on_Player_screen_entered")


func _process(_delta):
	$HUD/StartCountdownLabel.text = str(ceil($GameStartTimer.time_left)) + "..."
	$HUD/HealthBar1/HealthValue1.value = animated_health_p1
	$HUD/HealthBar2/HealthValue2.value = animated_health_p2
	if current_state == GAME_STATE.END:
		if Input.is_action_just_pressed("reload"):
			var _reloaded_succesfully = get_tree().reload_current_scene()
	
	update_arrow_position(arrow_1, player_1)
	update_arrow_position(arrow_2, player_2)


func update_arrow_position(arrow, player):
	
	var max_width = Globals.resolution.x
	var max_height = Globals.resolution.y
	
	arrow.global_position.x = clamp(player.global_position.x, 100, max_width - 100)
	arrow.global_position.y = clamp(player.global_position.y, 100, max_height - 100)
	
#	if player.global_position.x != 0:
#		m = player.global_position.y / player.global_position.x
#
#
#	if player.global_position.x > max_width:
#		arrow.global_position.x = max_width - 100
#		arrow.global_position.y = m * arrow.global_position.x
#
#	elif player.global_position.x < 0:
#		arrow.global_position.x = 100
#		arrow.global_position.y = m * arrow.global_position.x
#
#
#	if player.global_position.y > max_height:
#		arrow.global_position.y = max_height - 100
#		arrow.global_position.x = m / arrow.global_position.y
#
#	elif player.global_position.y < 0:
#		arrow.global_position.y = 100
#		arrow.global_position.x = m / 0.01
	
	arrow.look_at(player.global_position)


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
		$HUD/VictoryLabel.text = "Player 2 won! \n" + "Press \"R\" or \"Start\" to restart"
		emit_signal("game_won", 2)
	elif player_index == 2:
		$HUD/VictoryLabel.text = "Player 1 won! \n" + "Press \"R\" or \"Start\" to restart"
		emit_signal("game_won", 1)


func _on_Player_screen_exited(player_index):
	
	if player_index == 1:
		arrow_1.show()
	elif player_index == 2:
		arrow_2.show()


func _on_Player_screen_entered(player_index):
	
	if player_index == 1:
		arrow_1.hide()
	elif player_index == 2:
		arrow_2.hide()


func _on_World_game_won(player_victory):
	pass # Replace with function body.
