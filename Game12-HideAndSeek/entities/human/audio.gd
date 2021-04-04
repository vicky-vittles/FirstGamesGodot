extends Spatial

onready var tall_grass_sfx = $HighGrass

func tall_grass():
	tall_grass_sfx.play_random()
