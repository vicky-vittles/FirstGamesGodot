extends KinematicBody2D

const GRAVITY = 100
var velocity = Vector2()

func _physics_process(delta):
	
	velocity.y += GRAVITY * delta
	
	if not test_move(self.transform, velocity * delta):
		move_and_collide(velocity * delta)
	elif $FloorRaycast.is_colliding():
		velocity.y = 0	

func _on_Hurtbox_hit_landed(hit, direction):
	if hit.team == "player_attack":
		queue_free()
