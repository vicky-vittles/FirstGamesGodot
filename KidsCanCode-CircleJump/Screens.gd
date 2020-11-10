extends Node

signal start_game()

onready var TITLE_SCREEN = $TitleScreen
onready var SETTINGS_SCREEN = $SettingsScreen
onready var GAME_OVER_SCREEN = $GameOverScreen

var current_screen = null

func _ready():
	connect_buttons()
	change_screen(TITLE_SCREEN)

func connect_buttons():
	var buttons = get_tree().get_nodes_in_group("buttons")
	for button in buttons:
		button.connect("pressed", self, "_on_button_pressed", [button.name])

func change_screen(new_screen):
	
	if current_screen:
		current_screen.disappear()
		yield(current_screen.tween, "tween_completed")
	
	current_screen = new_screen
	
	if current_screen:
		current_screen.appear()
		yield(current_screen.tween, "tween_completed")

func _on_button_pressed(name):
	match name:
		"Home":
			change_screen(TITLE_SCREEN)
		"Play":
			change_screen(null)
			yield(get_tree().create_timer(0.5), "timeout")
			emit_signal("start_game")
		"Settings":
			change_screen(SETTINGS_SCREEN)
		_:
			pass

func game_over():
	change_screen(GAME_OVER_SCREEN)
