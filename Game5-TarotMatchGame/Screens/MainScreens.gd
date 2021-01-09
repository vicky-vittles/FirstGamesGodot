extends Node

signal new_game(opponent_type)

onready var screens = {"TitleScreen": $TitleScreen,
				"GameSelectScreen": $GameSelectScreen}
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

func quit():
	get_tree().quit()

func go_to_title_screen():
	change_screen("TitleScreen")

func _on_GameSelectScreen_new_game(opponent_type):
	emit_signal("new_game", opponent_type)
