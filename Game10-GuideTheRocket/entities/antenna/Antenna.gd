extends Area2D

signal touched_rocket()

var rocket_exploded : bool = false

onready var collision_shape = $CollisionShape
onready var animation_player = $AnimationPlayer

func _on_Rocket_spawn():
	rocket_exploded = false

func _physics_process(delta):
	if not rocket_exploded:
		global_position = get_global_mouse_position()
	var query = Physics2DShapeQueryParameters.new()
	query.set_transform(global_transform)
	query.set_shape(collision_shape.shape)
	query.collision_layer = self.collision_mask
	var space_state = get_world_2d().get_direct_space_state()
	var results = space_state.intersect_shape(query)
	for data in results:
		if data.collider.is_in_group("rocket"):
			if not rocket_exploded:
				Globals.set_cursor_default()
				animation_player.play("explode")
				emit_signal("touched_rocket")
			rocket_exploded = true
