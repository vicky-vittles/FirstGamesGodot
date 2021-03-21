extends Block

export (int) var WIDTH = 0
export (int) var HEIGHT = 0
export (bool) var CENTERED = false
export (preload("res://globals/Enums.gd").BLOCKS) var BLOCK_TYPE

onready var sprite = $Sprite
onready var collision_shape = $CollisionShape2D

func init(width: int, height: int, centered: bool, block_type: int):
	WIDTH = width
	HEIGHT = height
	CENTERED = centered
	BLOCK_TYPE = block_type

func get_border_position(border: int) -> Vector2:
	return get_central_position() + sign(border) * Globals.TILE_SIZE * Vector2(WIDTH/2,0)

func get_central_position() -> Vector2:
	if CENTERED:
		return global_position
	else:
		return global_position + Globals.TILE_SIZE * Vector2(WIDTH/2, HEIGHT/2)

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
