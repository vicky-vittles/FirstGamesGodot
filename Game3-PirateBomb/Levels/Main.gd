extends Node

func _ready():
	$TitleScreen/VBoxContainer/Buttons/Stage1.connect("pressed", self, "_on_Stage1_chosen")
	$TitleScreen/VBoxContainer/Buttons/Stage2.connect("pressed", self, "_on_Stage2_chosen")

func _on_Stage1_chosen():
	start_game(1)

func _on_Stage2_chosen():
	start_game(2)

func start_game(chosen_level):
	
	var title_screen = $TitleScreen
	remove_child(title_screen)
	title_screen.call_deferred("free")
	
	var game_resource = load("res://Levels/Game.tscn")
	var game = game_resource.instance()
	game.change_level(chosen_level)
	add_child(game)
