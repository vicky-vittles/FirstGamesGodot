extends Node2D

var presses : int = 0

func _on_Button_pressed():
	presses += 1
	$Label.text = str(presses)
