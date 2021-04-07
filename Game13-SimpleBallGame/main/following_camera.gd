extends Camera

export (Vector3) var offset
export (NodePath) var target_path
onready var target = get_node(target_path)

func _physics_process(delta):
	global_transform.origin = target.global_transform.origin + offset
