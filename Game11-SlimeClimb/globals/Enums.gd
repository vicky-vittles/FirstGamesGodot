extends Node

enum BLOCKS {
	DUMMY = 0,
	CAVE_BLOCK = 1,
	CAVE_BLOCK_TOP = 2,
	INVISIBLE = 3}

var BLOCK_SPRITES = {
	BLOCKS.DUMMY: preload("res://assets/images/blocks/dummy-placeholder.png"),
	BLOCKS.CAVE_BLOCK: preload("res://assets/images/blocks/cave-block.png"),
	BLOCKS.CAVE_BLOCK_TOP: preload("res://assets/images/blocks/cave-block-top.png"),
	BLOCKS.INVISIBLE: preload("res://assets/images/blocks/dummy-placeholder.png")}

var SCREENS_PER_LEVEL = {
	#Up to Level : number of screens
	3: 2,
	7: 3,
	13: 4,
	20: 5}

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

var SCROLL_SPEED_PER_LEVEL = {
	1: 60,
	3: 60,
	7: 70,
	10: 80,
	12: 100,
	15: 120}

enum PLAT_LEVELS {
	EASY,
	NORMAL,
	HARD,
	VERY_HARD}

var PLAT_DISTANCES = {
	PLAT_LEVELS.EASY: [5,6],
	PLAT_LEVELS.NORMAL: [10,12,14,16],
	PLAT_LEVELS.HARD: [18,19,20,21],
	PLAT_LEVELS.VERY_HARD: [23,24,25,26]}

var PLAT_HEIGHTS = {
	PLAT_LEVELS.EASY: [6,7,8],
	PLAT_LEVELS.NORMAL: [9,10,11],
	PLAT_LEVELS.HARD: [13,14,15],
	PLAT_LEVELS.VERY_HARD: [16,17,18]}

var PLAT_WIDTHS = {
	PLAT_LEVELS.EASY: [12,11],
	PLAT_LEVELS.NORMAL: [9,8],
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

func get_scroll_speed(level: int):
	for level_key in SCROLL_SPEED_PER_LEVEL.keys():
		if level <= level_key:
			return SCROLL_SPEED_PER_LEVEL[level_key]
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