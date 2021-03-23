extends Path2D

const PIECE_TEXTURE = preload("res://assets/images/slime/slime-arrow-piece.png")
export (int) var number_of_points = 10

onready var arrow_end = $"../ArrowEnd"

var arrow_rotation : float = 0.0

func _ready():
	for i in range(1,number_of_points+1):
		var sprite = Sprite.new()
		sprite.texture = PIECE_TEXTURE
		sprite.z_index = 1
		add_child(sprite)

func show_sprites():
	arrow_end.visible = true
	for i in get_child_count():
		if i > 0:
			get_child(i).visible = true

func hide_sprites():
	arrow_rotation = 0.0
	arrow_end.visible = false
	for child in get_children():
		child.visible = false

func get_sprite(i):
	return get_child(i-1)

func calculate_trajectory(target_point: Vector2, origin_point: Vector2, delta):
	var step_x = target_point.x / number_of_points
	var dx = target_point.x
	var dy = target_point.y
	for i in range(2, number_of_points+1):
		var x = i*step_x
		var y = parabola_function(x, dx, dy)
		get_sprite(i).position = Vector2(x,y)
	var arrow_x = step_x*(number_of_points+1)
	arrow_end.global_position = global_position + Vector2(arrow_x, parabola_function(arrow_x, dx, dy))
	var direction = sign(target_point.x)
	arrow_rotation += delta*direction*PI/4
	if direction == 1:
		arrow_end.rotation = arrow_rotation
	else:
		arrow_end.rotation = -180 + arrow_rotation

func parabola_function(x, dx, dy):
	return -dy/(dx*dx) * (x-dx)*(x-dx) + dy
