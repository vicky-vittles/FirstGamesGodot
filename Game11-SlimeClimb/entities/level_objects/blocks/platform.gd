extends Block

export (int) var WIDTH = 0
export (int) var HEIGHT = 0
export (bool) var CENTERED = false
export (bool) var ROUNDED = false
export (preload("res://globals/Enums.gd").BLOCKS) var BLOCK_TYPE

onready var sprite = $Sprite
onready var collision_shape = $CollisionShape2D

func init(width: int, height: int, centered: bool, rounded: bool, block_type: int):
	WIDTH = width
	HEIGHT = height
	CENTERED = centered
	ROUNDED = rounded
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
	
	var col_shape_pos = Vector2()
	collision_shape.shape = RectangleShape2D.new()
	if ROUNDED:
		var small_width = (WIDTH/2)-1
		collision_shape.shape.extents = Vector2(Globals.TILE_SIZE*(small_width), Globals.TILE_SIZE*HEIGHT/2)
		var circle_shape_1 = CollisionShape2D.new()
		var circle_shape_2 = CollisionShape2D.new()
		var circle_shape = CircleShape2D.new()
		circle_shape.radius = Globals.TILE_SIZE/2
		circle_shape_1.shape = circle_shape
		circle_shape_2.shape = circle_shape
		add_child(circle_shape_1)
		add_child(circle_shape_2)
		circle_shape_1.position = Vector2(Globals.TILE_SIZE*small_width,0)
		circle_shape_2.position = Vector2(-Globals.TILE_SIZE*small_width,0)
	else:
		collision_shape.shape.extents = Vector2(Globals.TILE_SIZE*WIDTH/2, Globals.TILE_SIZE*HEIGHT/2)
	if CENTERED:
		col_shape_pos = Vector2(0,0)
	else:
		col_shape_pos = Vector2(Globals.TILE_SIZE*WIDTH/2, Globals.TILE_SIZE*HEIGHT/2)
	collision_shape.position = col_shape_pos

func _ready():
	setup()
