extends Node2D

func set_aim_transparency(alpha: float):
	get_node("Line2D").default_color.a = alpha
