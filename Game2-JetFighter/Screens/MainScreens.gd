extends Node

signal start_vs_player_game()
signal start_vs_bot_game()


onready var screens = {"TitleScreen": $TitleScreen,
				"GameSelectScreen": $GameSelectScreen,
				"OptionsScreen": $OptionsScreen}
var actual_screen


func _ready():
	for screen in screens:
		screens[screen].hide_screen()
	change_screen("TitleScreen")


func change_screen(new_screen):
	new_screen = screens[new_screen]
	
	if actual_screen:
		actual_screen.hide_screen()
	
	actual_screen = new_screen
	actual_screen.show_screen()


func go_to_game_select():
	change_screen("GameSelectScreen")

func go_to_options():
	change_screen("OptionsScreen")

func quit():
	get_tree().quit()

func go_to_title_screen():
	change_screen("TitleScreen")

func new_vs_bot_game():
	emit_signal("start_vs_bot_game")

func new_vs_player_game():
	emit_signal("start_vs_player_game")
