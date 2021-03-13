extends CanvasLayer

signal start_game()

var game_started : bool = false

onready var animation_player = $root/AnimationPlayer

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if not game_started:
				animation_player.play("hide")
				emit_signal("start_game")
			game_started = true
