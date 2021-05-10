extends Area

export (Array, String) var collidable_groups

func _on_area_entered(area):
	for group in collidable_groups:
		if area.is_in_group(group):
			activate(area)

func _on_area_exited(area):
	pass # Replace with function body.

func _on_body_entered(body):
	for group in collidable_groups:
		if body.is_in_group(group):
			activate(body)

func _on_body_exited(body):
	pass # Replace with function body.

# Override
func activate(entity):
	pass
