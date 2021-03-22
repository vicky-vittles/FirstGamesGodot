extends Node2D

onready var background = $Background
onready var scrolling_level = $ScrollingLevel

var slime_made_first_jump : bool = false

func start():
	background.start()
	scrolling_level.start()

func _on_Slime_jump_started():
	if not slime_made_first_jump:
		start()
	slime_made_first_jump = true

func _on_DeathTrigger_player_died():
	print("death trigger")
