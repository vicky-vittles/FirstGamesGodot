extends Area

signal entered(entity)

export (Array, String) var collidable_groups
export (Globals.EDITOR_COLORS) var editor_color

#func _process(delta):
#	if Engine.editor_hint:
#		var editor_debug = get_node("Editor")
#		var new_material = Globals.EDITOR_COLOR_MATERIALS[editor_color]
#		print(new_material)
#		editor_debug.mesh.surface_set_material(0, new_material)

func _on_area_entered(area):
	for group in collidable_groups:
		if area.is_in_group(group):
			emit_signal("entered", area)

func _on_area_exited(area):
	pass # Replace with function body.

func _on_body_entered(body):
	for group in collidable_groups:
		if body.is_in_group(group):
			emit_signal("entered", body)

func _on_body_exited(body):
	pass # Replace with function body.
