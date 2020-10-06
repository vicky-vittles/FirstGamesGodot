extends RigidBody2D

enum DIRECTION {LEFT, RIGHT}
export (DIRECTION) var initial_direction = DIRECTION.RIGHT

const TILE_SIZE = 32
const FORCE = 11 * TILE_SIZE

var sound_is_muted = true


func _ready():
	if initial_direction == DIRECTION.LEFT:
		$Sprite.flip_h = true
		$CollisionShape2D.scale = Vector2(-1, 1)
		$CollisionShape2D2.scale = Vector2(-1, 1)
		$Hurtbox.scale = Vector2(-1, 1)


func _on_Hurtbox_area_entered(area):
	if area.is_in_group("explosion"):
		var explosion = (area as Explosion)
		var explosion_scale = explosion.scale.x - 1
		
		var hit_direction = (global_position - explosion.global_position).normalized().x
		
		apply_central_impulse((FORCE + explosion_scale * FORCE) * Vector2(hit_direction, -0.8))


func _on_Prop_sleeping_state_changed():
	if not sleeping and not $CollisionSFX.playing and not sound_is_muted:
		$CollisionSFX.play_random()


#func _on_Prop_body_entered(body):
#	if (body.is_in_group("player")) and linear_velocity.length() > 0 and not sound_is_muted:
#		$CollisionSFX.stop()
#		$CollisionSFX.play_random()


func _on_MuteTimer_timeout():
	sound_is_muted = false
