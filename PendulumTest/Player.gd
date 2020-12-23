extends KinematicBody2D

var theta : float = deg2rad(37)
var length : float = 250.0

var ang_acc : float = 0.0
var ang_vel : float = 0.0

func _physics_process(delta):
	
	var new_pos = Vector2(500, 250)
	new_pos.x += length * sin(theta)
	new_pos.y += length * -cos(theta)
	
	var velocity = new_pos - self.global_position
	
	move_and_collide(velocity * delta)
	
	ang_acc = PI * sin(theta)
	
	theta += ang_vel * delta
	ang_vel += ang_acc * delta
