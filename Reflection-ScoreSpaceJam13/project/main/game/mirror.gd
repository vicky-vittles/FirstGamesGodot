extends StaticBody2D

func _ready():
	for child in get_children():
		if child is CollisionPolygon2D:
			var polygon = Polygon2D.new()
			add_child(polygon)
			var points = []
			for point in child.polygon:
				points.append(point)
			polygon.polygons = points
			polygon.color = Color("ffffff")
