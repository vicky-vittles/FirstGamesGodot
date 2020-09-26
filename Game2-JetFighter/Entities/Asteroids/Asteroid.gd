extends KinematicBody2D

export (int) var SPEED = 0

var rotation_speed
var direction = Vector2()

func _ready():
	randomize()
	rotation_speed = randf() * 2*PI/3 - PI/3

func _physics_process(delta):
	
	rotate(rotation_speed * delta)
	
	var collision = move_and_collide(direction * SPEED * delta)
	if collision:
		direction = direction.bounce(collision.normal)
	
	if not $VisibilityNotifier2D.is_on_screen() and $LifetimeTimer.wait_time == 0:
		get_parent().remove_child(self)
		queue_free()
