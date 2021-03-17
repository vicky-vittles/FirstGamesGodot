extends Block

export (int) var WIDTH = 1
export (int) var HEIGHT = 1
export (PackedScene) var BLOCK_TYPE

onready var sprite = $Sprite

func _ready():
	sprite.visible = false
	assert(BLOCK_TYPE != null)
	assert(BLOCK_TYPE.instance() is Block)
	for w in WIDTH:
		for h in HEIGHT:
			var block = BLOCK_TYPE.instance()
			add_child(block)
			block.global_position = global_position + Vector2(
					w*Globals.TILE_SIZE, h*Globals.TILE_SIZE)
