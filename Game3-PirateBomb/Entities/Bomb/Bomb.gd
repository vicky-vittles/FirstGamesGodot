extends RigidBody2D

signal exploded()

class_name Bomb

const TILE_SIZE = 32
const FORCE = 15 * TILE_SIZE
const EXPLOSION = preload("res://Entities/Bomb/Explosion/Explosion.tscn")

const EXPLOSION_SCALE = Vector2(0.33, 0.33)

onready var new_scale = scale


func _on_FuseTimer_timeout():
	var explosion = EXPLOSION.instance()
	
	explosion.global_position = global_position
	explosion.global_rotation = 0
	
	explosion.scale = new_scale
	
	$"../../Explosions".add_child(explosion)
	
	emit_signal("exploded")
	
	get_parent().remove_child(self)
	queue_free()


func _on_Hurtbox_area_entered(area):
	if area.is_in_group("player_attack"):
		var direction = sign(area.position.x)
		
		apply_central_impulse(Vector2(FORCE * direction, 0))
		
	elif area.is_in_group("explosion"):
		var explosion = (area as Explosion)
		var direction_of_explosion = (global_position - explosion.global_position).normalized().x
		
		apply_central_impulse(Vector2(FORCE * direction_of_explosion, -FORCE * 0.7))
		
		var min_value = min(2, (explosion.scale + EXPLOSION_SCALE).x)
		new_scale = Vector2(min_value, min_value)
		
		$CollisionShape2D.scale = new_scale
		$AnimatedSprite.scale = new_scale
		$Hurtbox/CollisionShape2D.scale = new_scale
