extends Sprite

onready var player = $"../.."

func _ready():
	randomize()

func check_level():
	if player.whip_level == 3:
		hframes = 3
		vframes = 4

func change_color():
	if player.whip_level == 3:
		var n = randi() % 3 + 1
		frame = (frame + 3 * n) % (hframes * vframes)
