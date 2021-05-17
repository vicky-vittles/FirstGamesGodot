extends Node2D

const COLOR_1 = Color("9b9b9b")
const COLOR_2 = Color("ffffff")

func set_aim_color(t: float):
	get_node("Line2D").default_color = lerp(COLOR_1, COLOR_2, t)

func set_aim_transparency(alpha: float):
	get_node("Line2D").default_color.a = alpha
