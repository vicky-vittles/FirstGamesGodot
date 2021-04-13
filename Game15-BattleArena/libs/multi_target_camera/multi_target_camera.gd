extends Camera2D

export (float) var move_speed = 0.5
export (float) var zoom_speed = 0.25
export (float) var min_zoom = 1.0
export (float) var max_zoom = 2.0
export (Vector2) var margin = Vector2(100,200)

export (NodePath) var players_path
onready var players = get_node(players_path)
onready var screen_size = get_viewport_rect().size

func _process(delta):
	var targets = players.get_children()
	if not targets:
		return
	
	# Move camera
	var p = Vector2.ZERO
	for target in targets:
		p += target.position
	p /= targets.size()
	position = lerp(position, p, move_speed)
	
	# Zoom
	var r = Rect2(position, Vector2.ONE)
	for target in targets:
		r = r.expand(target.position)
	r = r.grow_individual(margin.x, margin.y, margin.x, margin.y)
	var d = max(r.size.x, r.size.y)
	var z
	if r.size.x > r.size.y * screen_size.aspect():
		z = clamp(r.size.x / screen_size.x, min_zoom, max_zoom)
	else:
		z = clamp(r.size.y / screen_size.y, min_zoom, max_zoom)
	zoom = lerp(zoom, Vector2.ONE * z, zoom_speed)
