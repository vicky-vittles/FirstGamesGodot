extends Node

signal start_game()

onready var click = $Click
onready var TITLE_SCREEN = $TitleScreen
onready var SETTINGS_SCREEN = $SettingsScreen
onready var GAME_OVER_SCREEN = $GameOverScreen

onready var score_label = $GameOverScreen/MarginContainer/VBoxContainer/Scores/Score
onready var highscore_label = $GameOverScreen/MarginContainer/VBoxContainer/Scores/Best

var sound_buttons = {true: preload("res://Assets/images/buttons/audioOn.png"),
					false: preload("res://Assets/images/buttons/audioOff.png")}
var music_buttons = {true: preload("res://Assets/images/buttons/musicOn.png"),
					false: preload("res://Assets/images/buttons/musicOff.png")}

var current_screen = null

func _ready():
	connect_buttons()
	change_screen(TITLE_SCREEN)

func connect_buttons():
	var buttons = get_tree().get_nodes_in_group("buttons")
	for button in buttons:
		button.connect("pressed", self, "_on_button_pressed", [button])

func change_screen(new_screen):
	
	if current_screen:
		current_screen.disappear()
		yield(current_screen.tween, "tween_completed")
	
	current_screen = new_screen
	
	if current_screen:
		current_screen.appear()
		yield(current_screen.tween, "tween_completed")

func _on_button_pressed(button):
	if Settings.enable_sound:
		click.play()
	
	match button.name:
		"Sound":
			Settings.enable_sound = !Settings.enable_sound
			button.texture_normal = sound_buttons[Settings.enable_sound]
		"Music":
			Settings.enable_music = !Settings.enable_music
			button.texture_normal = music_buttons[Settings.enable_music]
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

func game_over(score, highscore):
	score_label.text = "Score: " + str(score)
	highscore_label.text = "Highscore: " + str(highscore)
	change_screen(GAME_OVER_SCREEN)
