extends Area2D

export (int) var acceleration = 100
export (int) var initial_speed = 50
export (int) var max_speed = 300
export (int) var damage = 0

onready var collision_shape = $CollisionShape

var direction = Vector2()
var velocity : Vector2

func fire(dir: Vector2):
	direction = dir
	rotation = direction.angle()
	velocity = direction * initial_speed

func _physics_process(delta):
	velocity += acceleration * direction * delta
	velocity.clamped(max_speed)
	
	var query = Physics2DShapeQueryParameters.new()
	query.transform = self.global_transform
	query.set_shape(collision_shape.shape)
	query.collision_layer = self.collision_layer
	var space_state = get_world_2d().get_direct_space_state()
	var results = space_state.intersect_shape(query)
	for data in results:
		if data.collider.is_in_group("hero"):
			print(data.collider.name)
