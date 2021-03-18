extends Node2D

onready var background = $Background
onready var scrolling_level = $ScrollingLevel

func start():
	background.start()
	scrolling_level.start()

func _on_Slime_jump_started():
	start()

func _on_DeathTrigger_player_died():
	print("death trigger")
