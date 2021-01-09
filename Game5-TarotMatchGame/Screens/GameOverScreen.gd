extends CanvasLayer

onready var label = $MarginContainer/VBoxContainer/Label


func set_winning_message(is_a_victory : bool, player_points):
	var message
	if is_a_victory:
		var winning_player = player_points[0]
		message = "Player " + str(winning_player[0]) + " has won!\r\n\r\n"
	else:
		message = "It's a tie!\r\n\r\n"
	
	for p in player_points:
		message += "Player " + str(p[0]) + ": " + str(p[1]) + " points\r\n"
	
	label.text = message


func _on_Button_pressed():
	get_tree().reload_current_scene()
