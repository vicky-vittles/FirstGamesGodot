extends Block

export (int) var WIDTH = 0
export (int) var HEIGHT = 0
export (bool) var CENTERED = false
export (Enums.BLOCKS) var BLOCK_TYPE

onready var sprite = $Sprite
onready var collision_shape = $CollisionShape2D

func init(width: int, height: int, centered: bool, block_type: int):
	WIDTH = width
	HEIGHT = height
	CENTERED = centered
	BLOCK_TYPE = block_type

func setup():
	assert(WIDTH != 0)
	assert(HEIGHT != 0)
	assert(BLOCK_TYPE != 0)
	
	sprite.region_rect = Rect2(0, 0, Globals.TILE_SIZE * WIDTH, Globals.TILE_SIZE * HEIGHT)
	sprite.texture = Enums.BLOCK_SPRITES[BLOCK_TYPE]
	sprite.region_enabled = true
	sprite.centered = CENTERED
	
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.extents = Vector2(Globals.TILE_SIZE*WIDTH/2, Globals.TILE_SIZE*HEIGHT/2)
	if CENTERED:
		collision_shape.position = Vector2(0,0)
	else:
		collision_shape.position = Vector2(Globals.TILE_SIZE*WIDTH/2, Globals.TILE_SIZE*HEIGHT/2)

func _ready():
	setup()
