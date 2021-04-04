extends "res://systems/menus/sequences/base_sequence.gd"

const EMPTY_SCREEN = "EmptyScreen"
const PAUSE_SCREEN = "PauseScreen"
const OPTIONS_SCREEN = "OptionsScreen"

func go_to_empty_screen():
	change_screen(EMPTY_SCREEN)

func go_to_pause_screen():
	change_screen(PAUSE_SCREEN)

func go_to_options_screen():
	change_screen(OPTIONS_SCREEN)
