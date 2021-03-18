extends Block

export (int) var WIDTH = 0
export (int) var HEIGHT = 0
export (PackedScene) var BLOCK_TYPE

func init(width: int, height: int, block_type):
	WIDTH = width
	HEIGHT = height
	BLOCK_TYPE = block_type

func setup():
	assert(WIDTH != 0)
	assert(HEIGHT != 0)
	assert(BLOCK_TYPE != null)
	assert(BLOCK_TYPE.instance() is Block)
	for w in WIDTH:
		for h in HEIGHT:
			var block = BLOCK_TYPE.instance()
			add_child(block)
			block.global_position = global_position + Vector2(
					w*Globals.TILE_SIZE, h*Globals.TILE_SIZE)

func _ready():
	setup()
