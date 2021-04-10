extends CanvasLayer

signal play_again()

onready var animation_player = $AnimationPlayer
onready var placement_label = $root/control/PlacementLabel
onready var start_game_label = $root/StartGameLabel
onready var start_game_timer = $StartGameTimer
onready var player_won_label = $root/PlayerWonLabel
onready var play_again_button = $root/control2/PlayAgain

onready var start_game_text = start_game_label.text


func _physics_process(_delta):
	set_start_game_label()

func set_start_game_label():
	var time = int(start_game_timer.time_left) + 1
	start_game_label.text = start_game_text % time

func _on_StartGameTimer_timeout():
	start_game_label.hide()
	animation_player.play("start_game")

func _on_Game_update_placement(cars_ordered):
	var text = ""
	var position = 1
	for car in cars_ordered:
		text += "%s  |  %s \n" % [get_placement_name(position), car.player_name]
		position += 1
	if text != placement_label.text:
		placement_label.text = text
		animation_player.play("placement_updated")

func get_placement_name(position: int) -> String:
	match position:
		1:
			return "1st"
		2:
			return "2nd"
		3:
			return "3rd"
		_:
			return str(position)+"th"

func _on_Game_player_won(player):
	player_won_label.text = player.player_name + " venceu!"
	animation_player.play("end_game")

func _on_PlayAgain_pressed():
	player_won_label.text = "Aguardando outro jogador..."
	play_again_button.disabled = true
	get_tree().paused = false
	emit_signal("play_again")
