extends KinematicBody2D

const SPEED : int = 100
export (Vector2) var direction = Vector2(0, 0)

var rotation_force : float = PI/2
var velocity = Vector2()

func _ready():
	randomize()

func _physics_process(delta):
	rotate(rotation_force * delta)
	velocity = direction * SPEED
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.collider
		if collider.is_in_group("terrain"):
			direction = direction.bounce(collision.normal)
			rotation_force = rand_range(-PI/2, PI/2)
