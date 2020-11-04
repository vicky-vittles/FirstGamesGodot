extends Node2D

signal bomb_exploded()

var match_is_over = false
var alive_players = [1, 2]


func _ready():
	$Music.play()
	
	$Player1/Health.connect("update_health", self, "_on_Player_update_health")
	$Player2/Health.connect("update_health", self, "_on_Player_update_health")
	
	$Player1/Health.connect("died", self, "_on_Player_died")
	$Player2/Health.connect("died", self, "_on_Player_died")
	
	$Player1.connect("bomb_exploded", self, "_on_Player_bomb_exploded")
	$Player2.connect("bomb_exploded", self, "_on_Player_bomb_exploded")


func _physics_process(delta):
	if match_is_over:
		if Input.is_action_just_pressed("reload"):
			get_tree().reload_current_scene()


func _on_Player_update_health(player_index, new_amount):
	var health_bar = get_node("HealthBar" + str(player_index))
	$Effects/SlowTime.start(0.2, 0.6)
	
	if new_amount == 2:
		health_bar.get_node("Heart3").hide()
	elif new_amount == 1:
		health_bar.get_node("Heart2").hide()
	elif new_amount == 0:
		health_bar.get_node("Heart1").hide()


func _on_Player_died(player_index):
	
	for i in alive_players.size():
		if alive_players[i] == player_index:
			alive_players[i] = 0
	
	var dead_players = 0
	var winner = 0
	for i in alive_players.size():
		if alive_players[i] == 0:
			dead_players + 1
		else:
			winner = alive_players[i]
	
	if winner != 0:
		$Music.stop()
		$Effects/SlowTime.start(0.6, 0.9)
		
		match_is_over = true
		$VictoryLabel.show()
		if winner == 1:
			$VictoryLabel.text = "Jogador 1 venceu! \n Pressione Start para recomeçar"
		elif winner == 2:
			$VictoryLabel.text = "Jogador 2 venceu! \n Pressione Start para recomeçar"


func _on_Player_bomb_exploded(player_index):
	emit_signal("bomb_exploded")
