extends Area2D

signal hit_landed(area)

export (Resource) var hit


func disable_shapes():
	for i in get_child_count():
		var child = get_child(i)
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)


func _on_area_entered(area):
	if not area.is_in_group(hit.team):
		emit_signal("hit_landed", area)
