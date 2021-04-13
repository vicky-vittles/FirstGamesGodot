extends Node

enum HERO_COLOURS {
	GREEN = 0,
	RED = 1,
	BLUE = 2,
	YELLOW = 3}
const HERO_SPRITES = {
	HERO_COLOURS.GREEN: preload("res://assets/dino-green.png"),
	HERO_COLOURS.RED: preload("res://assets/dino-red.png"),
	HERO_COLOURS.BLUE: preload("res://assets/dino-blue.png"),
	HERO_COLOURS.YELLOW: preload("res://assets/dino-yellow.png")}
