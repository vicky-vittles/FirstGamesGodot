extends "res://systems/menus/sequences/base_sequence.gd"

signal start_game_as_assassin()

const TITLE_SCREEN = "TitleScreen"
const OPTIONS_SCREEN = "OptionsScreen"
const CHOOSE_GAMEMODE_SCREEN = "ChooseGamemode"

func go_to_title_screen():
	change_screen(TITLE_SCREEN)

func go_to_options():
	change_screen(OPTIONS_SCREEN)

func go_to_choose_gamemode():
	change_screen(CHOOSE_GAMEMODE_SCREEN)

func quit_game():
	get_tree().quit()
