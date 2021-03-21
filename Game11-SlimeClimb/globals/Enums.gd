extends Node

enum BLOCKS {
	DUMMY = 0,
	CAVE_BLOCK = 1,
	CAVE_BLOCK_TOP = 2,
	INVISIBLE = 3}

var BLOCK_SPRITES = {
	BLOCKS.DUMMY: preload("res://assets/blocks/dummy-placeholder.png"),
	BLOCKS.CAVE_BLOCK: preload("res://assets/blocks/cave-block.png"),
	BLOCKS.CAVE_BLOCK_TOP: preload("res://assets/blocks/cave-block-top.png"),
	BLOCKS.INVISIBLE: preload("res://assets/blocks/dummy-placeholder.png")}

var SCREENS_PER_LEVEL = {
	#Up to Level : number of screens
	3: 4,
	7: 5,
	13: 6,
	20: 7}

var PLATFORMS_PER_SCREEN = {
	#Up to level : number of platforms
	6: 4,
	10: 3,
	15: 2,
	25: 1}

var DIFFICULTY_PER_LEVEL = {
	#Up to level : difficulty
	4: PLAT_LEVELS.EASY,
	9: PLAT_LEVELS.NORMAL,
	15: PLAT_LEVELS.HARD,
	25: PLAT_LEVELS.VERY_HARD}

enum PLAT_LEVELS {
	EASY,
	NORMAL,
	HARD,
	VERY_HARD}

var PLAT_DISTANCES = {
	PLAT_LEVELS.EASY: [7,8,9,10],
	PLAT_LEVELS.NORMAL: [12,14,15,16],
	PLAT_LEVELS.HARD: [18,19,20,21],
	PLAT_LEVELS.VERY_HARD: [23,24,25,26]}

var PLAT_HEIGHTS = {
	PLAT_LEVELS.EASY: [6,7,8],
	PLAT_LEVELS.NORMAL: [9,10,11],
	PLAT_LEVELS.HARD: [13,14,15],
	PLAT_LEVELS.VERY_HARD: [16,17,18]}

var PLAT_WIDTHS = {
	PLAT_LEVELS.EASY: [14,13,12,11],
	PLAT_LEVELS.NORMAL: [10,9,8,7],
	PLAT_LEVELS.HARD: [6,5,4],
	PLAT_LEVELS.VERY_HARD: [3,2,1]}


# Uses level ID
func get_total_screens(level: int):
	for level_key in SCREENS_PER_LEVEL.keys():
		if level <= level_key:
			return SCREENS_PER_LEVEL[level_key]
	return 0

func get_total_platforms(level: int):
	for level_key in PLATFORMS_PER_SCREEN.keys():
		if level <= level_key:
			return PLATFORMS_PER_SCREEN[level_key]
	return 0

func get_level_difficulty(level: int):
	for level_key in DIFFICULTY_PER_LEVEL.keys():
		if level <= level_key:
			return DIFFICULTY_PER_LEVEL[level_key]
	return 0


# Uses level difficulty
func get_rand_distance(level_difficulty: int):
	return PLAT_DISTANCES[level_difficulty][randi() % PLAT_DISTANCES[level_difficulty].size()]

func get_rand_height(level_difficulty: int):
	return PLAT_HEIGHTS[level_difficulty][randi() % PLAT_HEIGHTS[level_difficulty].size()]

func get_rand_width(level_difficulty: int):
	return PLAT_WIDTHS[level_difficulty][randi() % PLAT_WIDTHS[level_difficulty].size()]
