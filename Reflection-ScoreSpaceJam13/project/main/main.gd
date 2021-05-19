extends Node

func _ready():
	get_tree().paused = true

func _process(delta):
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()

func _on_Play_pressed():
	get_tree().paused = false
	get_node("AnimationPlayer").play("start")
	get_node("GameStart").start()

func _on_GameStart_timeout():
	get_tree().paused = false
	get_node("Game").start_game()

func _on_Game_game_over():
	get_node("AnimationPlayer").play("game_over")
