extends Area

export (Array,String) var collidable_groups
export (Array,String) var excluding_groups
var is_colliding : bool = false

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	for body_group in body.get_groups():
		if not collidable_groups.has(body_group) or excluding_groups.has(body_group):
			return
	is_colliding = true

func _on_body_exited(body):
	for body_group in body.get_groups():
		if not collidable_groups.has(body_group) or excluding_groups.has(body_group):
			return
	is_colliding = false
