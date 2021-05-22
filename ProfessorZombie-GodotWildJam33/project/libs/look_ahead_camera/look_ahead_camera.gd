extends Camera2D

export (float, 0.0, 1.0) var THRESHOLD = 0.5

export (int) var amount = 100
export (NodePath) var body_path
onready var body = get_node(body)

func lerp_with_target(target: Vector2):
	if global_position.distance_to(target) > amount:
		target.cl
	offset += lerp(position, )
