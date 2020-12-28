extends Node

onready var screens = {"EmptyScreen": $EmptyScreen,
				"PausedScreen": $PausedScreen,
				"GameOverScreen": $GameOverScreen,
				"OptionsScreen": $OptionsScreen}
var actual_screen


func _ready():
	for screen in screens:
		screens[screen].hide_screen()
	change_screen("EmptyScreen")


func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		change_screen("PausedScreen")


func change_screen(new_screen):
	new_screen = screens[new_screen]
	
	if actual_screen:
		actual_screen.hide_screen()
	
	actual_screen = new_screen
	actual_screen.show_screen()

func go_to_empty_screen():
	get_tree().paused = false
	change_screen("EmptyScreen")

func go_to_options_screen():
	change_screen("OptionsScreen")

func go_to_pause_screen():
	change_screen("PausedScreen")

func go_to_title_screen():
	get_tree().paused = false
	get_tree().reload_current_scene()

func go_to_game_over_screen(message):
	change_screen("GameOverScreen")
	screens["GameOverScreen"].set_message(message)
