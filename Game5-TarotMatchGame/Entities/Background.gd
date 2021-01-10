extends Sprite

const BACKGROUNDS = {
				1: preload("res://Assets/bg-1.png"),
				2: preload("res://Assets/bg-2.png"),
				3: preload("res://Assets/bg-3.png"),
				4: preload("res://Assets/bg-4.png")}

func _ready():
	randomize()
	var rand_index = (randi() % 4) + 1
	texture = BACKGROUNDS[rand_index]
