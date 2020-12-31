extends Camera2D

func _ready():
	get_parent().connect("bomb_exploded", self, "_on_Level_bomb_exploded")

func _on_Level_bomb_exploded():
	$ScreenShake.start(0.2, 15, 4, 1)
