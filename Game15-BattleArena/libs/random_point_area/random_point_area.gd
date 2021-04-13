extends Area2D

func _ready():
	randomize()

func get_random_point() -> Vector2:
	var collision_shape = get_node("CollisionShape")
	var size = 2*collision_shape.shape.extents
	
	var rand_pos_x = posmod(randi(),size.x) - (size.x/2) + global_position.x
	var rand_pos_y = posmod(randi(),size.y) - (size.y/2) + global_position.y
	var rand_pos = Vector2(rand_pos_x, rand_pos_y)
	print(rand_pos)
	return rand_pos
