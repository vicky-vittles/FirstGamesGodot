extends Spatial

onready var win_label = $CanvasLayer/root/Label

func _ready():
	win_label.hide()

func _on_EndGoal_win():
	win_label.show()
