extends Node2D

onready var spots = $Level/Spots
onready var level_cleared_dialog = $UI/AcceptDialog
onready var moves_label = $UI/MovesLabel
onready var player = $Player

func _process(delta):
	moves_label.text = "Moves: " + str(player.steps)
	
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
	
	if check_victory():
		level_cleared_dialog.show()

func check_victory():
	for child in spots.get_children():
		if not child.occupied:
			return false
	return true
