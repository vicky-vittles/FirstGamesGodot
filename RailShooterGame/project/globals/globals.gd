extends Node

enum EDITOR_COLORS { RED, BLUE, GREEN, YELLOW, ORANGE, PURPLE, WHITE, BLACK }
var EDITOR_COLOR_MATERIALS = {}

func _ready():
	var colors = {
		EDITOR_COLORS.RED: Color.red,
		EDITOR_COLORS.BLUE: Color.blue,
		EDITOR_COLORS.GREEN: Color.green,
		EDITOR_COLORS.YELLOW: Color.yellow,
		EDITOR_COLORS.ORANGE: Color.orange,
		EDITOR_COLORS.PURPLE: Color.purple,
		EDITOR_COLORS.WHITE: Color.white,
		EDITOR_COLORS.BLACK: Color.black}
	for color in colors:
		var material = SpatialMaterial.new()
		material.flags_transparent = true
		material.albedo_color = colors[color]
		material.albedo_color.a = 160.0
		EDITOR_COLOR_MATERIALS[color] = material
