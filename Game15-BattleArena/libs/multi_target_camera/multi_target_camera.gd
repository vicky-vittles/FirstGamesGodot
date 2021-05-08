extends Camera2D

export (float) var move_speed = 0.5
export (float) var zoom_speed = 0.25
export (float) var min_zoom = 1.0
export (float) var max_zoom = 2.0
export (Vector2) var margin = Vector2(100,200)

export (NodePath) var players_path
onready var players = get_node(players_path)
onready var screen_size = get_viewport_rect().size

var draw_p = Vector2()
var draw_r = Rect2()

func _draw():
	draw_circle(draw_p-position, 5.0, Color.green)
	draw_rect(Rect2(draw_r.position-position, draw_r.size), Color.red, false, 5.0)

func _process(delta):
	var targets = players.players_on_screen
	if not targets:
		return
	
	# Move camera
	var p = Vector2.ZERO
	for target in targets:
		p += target.global_position
	p /= targets.size()
	global_position = lerp(global_position, p, move_speed)
	draw_p = p
	
	# Zoom
	var r = Rect2(global_position, Vector2.ONE)
	for target in targets:
		r = r.expand(target.global_position)
	r = r.grow_individual(margin.x, margin.y, margin.x, margin.y)
	var d = max(r.size.x, r.size.y)
	var z
	if r.size.x > r.size.y * screen_size.aspect():
		z = clamp(r.size.x / screen_size.x, min_zoom, max_zoom)
	else:
		z = clamp(r.size.y / screen_size.y, min_zoom, max_zoom)
	zoom = lerp(zoom, Vector2.ONE * z, zoom_speed)
	draw_r = r
	
	#update()
