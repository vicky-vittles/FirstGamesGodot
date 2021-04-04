extends Spatial

onready var area = $Area

func _physics_process(delta):
	if area.is_colliding:
		area.colliding_body.audio.tall_grass()
