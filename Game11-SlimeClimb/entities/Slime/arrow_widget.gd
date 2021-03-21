extends Path2D

const PIECE_TEXTURE = preload("res://assets/slime/slime-arrow-piece.png")
export (int) var number_of_points = 10

func _ready():
	for i in range(1,number_of_points+1):
		var sprite = Sprite.new()
		sprite.texture = PIECE_TEXTURE
		add_child(sprite)

func show_sprites():
	for child in get_children():
		child.visible = true

func hide_sprites():
	for child in get_children():
		child.visible = false

func get_sprite(i):
	return get_child(i-1)

func calculate_trajectory(target_point: Vector2, origin_point: Vector2):
	var step_x = target_point.x / number_of_points
	for i in range(1, number_of_points+1):
		var x = i*step_x
		var dx = target_point.x
		var dy = target_point.y
		var y = -dy/(dx*dx) * (x-dx)*(x-dx) + dy
		get_sprite(i).position = Vector2(x,y)
