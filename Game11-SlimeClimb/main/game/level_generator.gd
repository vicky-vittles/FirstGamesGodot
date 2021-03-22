extends Node

const SCREEN_WIDTH : int = 640
const SCREEN_HEIGHT : int = 480
onready var tile_size = Globals.TILE_SIZE
onready var SCREEN_WIDTH_TILES : int = SCREEN_WIDTH / tile_size
onready var SCREEN_HEIGHT_TILES : int = SCREEN_HEIGHT / tile_size
const PLATFORM = preload("res://entities/level_objects/blocks/Platform.tscn")

onready var scrolling_level = get_parent()
onready var level_end = $"../LevelEnd"
onready var reset_point = $"../../ResetPoint"
onready var platforms = $"../Platforms"
onready var slime = $"../Slime"

export (int) var initial_level = 1
onready var current_level : int = initial_level

func _ready():
	randomize()
	generate_level(current_level)

func generate_level(id: int):
	var screens_number = Enums.get_total_screens(id) # Number of screens after LevelStart
	level_end.global_position = get_screen_origin(screens_number+2)
	reset_point.position = (screens_number+1) * Vector2(0, SCREEN_HEIGHT)
	
	for screen_id in range(1, screens_number+1):
		generate_screen(id, screen_id)

func generate_screen(level_id: int, screen_id: int):
	var screen_origin = get_screen_origin(screen_id)
	var platforms_number = Enums.get_total_platforms(level_id)
	
	# Generate initial platform, save it, and prepare data object
	var data = {
		"plat_id": 1,
		"level_id": level_id,
		"prev_platform": null,
		"screen_origin": screen_origin}
	var prev_platform = generate_platform(data)
	platforms_number -= 1
	
	# Alter data object for next platforms
	# Generate remaining platforms
	for plat_id in platforms_number:
		data["plat_id"] = plat_id
		data["prev_platform"] = prev_platform
		prev_platform = generate_platform(data)

func generate_platform(data):
	var level_id = data["level_id"]
	var screen_origin = data["screen_origin"]
	var prev_platform = data["prev_platform"]
	var next_platform = PLATFORM.instance()
	
	var level_difficulty = Enums.get_level_difficulty(level_id)
	var rand_distance = Enums.get_rand_distance(level_difficulty)
	var rand_height = Enums.get_rand_height(level_difficulty)
	var rand_width = Enums.get_rand_width(level_difficulty)
	var final_pos = tile_size * Vector2(20,3)
	
	if prev_platform == null:
		next_platform.init(8, 1, true, true, Enums.BLOCKS.CAVE_BLOCK)
	else:
		var central_pos = prev_platform.get_central_position()-screen_origin
		central_pos.x = clamp(central_pos.x, 0, SCREEN_WIDTH)
		var central_pos_offset = tile_size*(prev_platform.WIDTH/2)
		
		var space_available_r = SCREEN_WIDTH-clamp(central_pos.x+central_pos_offset, 0, SCREEN_WIDTH)
		var space_available_l = clamp(central_pos.x-central_pos_offset, 0, SCREEN_WIDTH)
		var direction_to_put_plat : int = 1
		if space_available_r >= space_available_l:
			#Put platform on the right
			direction_to_put_plat = 1
		else:
			#Put platform on the left
			direction_to_put_plat = -1
		var diff_r_and_l = abs(space_available_l - space_available_r)
		if diff_r_and_l <= 5 * Globals.TILE_SIZE:
			direction_to_put_plat = pow(-1, randi() % 2)
		
		var prev_plat_border = prev_platform.get_border_position(direction_to_put_plat)-screen_origin
		var pos_x = prev_plat_border.x + direction_to_put_plat*(tile_size*rand_distance + tile_size*rand_width/2)
		var rand_variation = ((randf()*2.0)-1.0)*tile_size
		final_pos.x = clamp(pos_x, 0, SCREEN_WIDTH) + rand_variation
		final_pos.y = prev_plat_border.y - tile_size*rand_height
		next_platform.init(rand_width, 1, true, true, Enums.BLOCKS.CAVE_BLOCK)
	
	platforms.add_child(next_platform)
	next_platform.global_position = final_pos + screen_origin
	
	return next_platform

func get_screen_origin(screen_id: int) -> Vector2:
	return Vector2(0, -1*(screen_id-1)*SCREEN_HEIGHT)

func update_level(level_id):
	# Clear previous level
	for platform in platforms.get_children():
		platform.queue_free()
	
	# Generate next level
	current_level = level_id
	generate_level(level_id)
