extends Node

const GAME = preload("res://main/game/Game.tscn")
const GAME_SEQUENCE = preload("res://systems/menus/sequences/GameSequence.tscn")
const QUIT_SEQUENCE = preload("res://systems/menus/sequences/QuitSequence.tscn")

onready var main_sequence = $MainSequence
onready var fgd_exporter = $FGDExporter

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	TranslationServer.set_locale("en")

func _process(delta):
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func game_ended():
	remove_child(get_node("GameSequence"))
	var quit_sequence = QUIT_SEQUENCE.instance()
	add_child(quit_sequence)


func start_game_as_assassin():
	remove_child(main_sequence)
	remove_child(fgd_exporter)
	var new_game = GAME.instance()
	var game_sequence = GAME_SEQUENCE.instance()
	add_child(new_game)
	add_child(game_sequence)
	new_game.connect("game_ended", self, "game_ended")
