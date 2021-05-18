extends Line2D

func _on_Player_path_add_point(point):
	add_point(point - global_position)

func _on_Player_path_clear_points():
	clear_points()
