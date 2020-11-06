extends KinematicBody2D

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

onready var ray = $RayCast2D
onready var tween = $Tween
onready var sprite = $Sprite

func move(direction):
	if direction != Vector2.ZERO:
		var end_position = direction * Globals.TILE_SIZE
		ray.cast_to = end_position
		ray.force_raycast_update()
		tween.interpolate_property(sprite, "position", sprite.position - end_position, Vector2.ZERO, 0.1, TRANS, EASE)
		#tween.interpolate_property(self, "position", position, position + end_position, 0.1, TRANS, EASE)
		
		if not ray.is_colliding():
			position += end_position
			tween.start()
			return true
		return false
