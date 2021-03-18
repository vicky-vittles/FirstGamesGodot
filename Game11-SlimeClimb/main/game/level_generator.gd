extends Node

const SCREEN_WIDTH : int = 640
const SCREEN_HEIGHT : int = 480
onready var SCREEN_WIDTH_TILES : int = SCREEN_WIDTH / Globals.TILE_SIZE
onready var SCREEN_HEIGHT_TILES : int = SCREEN_HEIGHT / Globals.TILE_SIZE
const PLATFORM = preload("res://entities/level_objects/blocks/Platform.tscn")
const CAVE_BLOCK = preload("res://entities/level_objects/blocks/CaveBlock.tscn")

onready var scrolling_level = get_parent()
onready var level_end = $"../LevelEnd"
onready var reset_point = $"../../ResetPoint"
onready var platforms = $"../Platforms"
onready var slime = $"../Slime"

var alternating_plat : bool = false

export (int) var initial_level = 1
onready var current_level : int = initial_level

func _ready():
	randomize()
	generate_level(current_level)

func generate_level(id: int):
	var screens_number = 3 # Number of screens after LevelStart
	level_end.global_position = get_screen_origin(screens_number+2)
	reset_point.position = (screens_number+1) * Vector2(0, SCREEN_HEIGHT)
	
	for screen_id in range(1, screens_number+1):
		generate_screen(screen_id)

func generate_screen(screen_id: int):
	var screen_origin = get_screen_origin(screen_id)
	var platforms_number = 5
	var height_range = int(SCREEN_HEIGHT_TILES/platforms_number)
	
	for plat_id in platforms_number:
		generate_platform(plat_id, height_range, screen_origin)

func generate_platform(plat_id: int, height_range: int, screen_origin: Vector2):
	var platform = PLATFORM.instance()
	platform.init(8, 1, CAVE_BLOCK)
	platforms.add_child(platform)
	
	alternating_plat = !alternating_plat
	var rand_pos_x
	if alternating_plat:
		rand_pos_x = randi()%8
	else:
		rand_pos_x = 24+(randi()%8)
	var rand_pos_y = -plat_id*height_range + randi()%height_range
	platform.global_position = screen_origin + Vector2(rand_pos_x, rand_pos_y) * Globals.TILE_SIZE

func get_screen_origin(screen_id: int) -> Vector2:
	return Vector2(0, -1*(screen_id-1)*SCREEN_HEIGHT)
