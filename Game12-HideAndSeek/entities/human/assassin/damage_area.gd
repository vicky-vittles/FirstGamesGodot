extends Area

export (NodePath) var human_path
onready var human = get_node(human_path)

func _on_DamageArea_body_entered(body):
	if body.is_in_group("human") and body.has_method("hurt") and body != human:
		body.hurt()
