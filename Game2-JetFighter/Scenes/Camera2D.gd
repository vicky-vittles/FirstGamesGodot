extends Camera2D

func _ready():
	get_parent().connect("player_took_damage", self, "_on_Level_player_took_damage")

func _on_Level_player_took_damage():
	$ScreenShake.start(0.2, 15, 4, 1)
