extends Node

enum BLOCKS {
	DUMMY,
	CAVE_BLOCK,
	CAVE_BLOCK_TOP}

var BLOCK_SPRITES = {
	BLOCKS.DUMMY: preload("res://assets/blocks/dummy-placeholder.png"),
	BLOCKS.CAVE_BLOCK: preload("res://assets/blocks/cave-block.png"),
	BLOCKS.CAVE_BLOCK_TOP: preload("res://assets/blocks/cave-block-top.png")}

enum PLAT_LEVELS {
	EASY,
	NORMAL,
	HARD}

var PLAT_HEIGHTS = {
	PLAT_LEVELS.EASY: [3.4,5,6],
	PLAT_LEVELS.NORMAL: [7,8,9,10,11],
	PLAT_LEVELS.HARD: [12,13,14,15,16]}
