extends KinematicBody2D

const TARGET_OFFSET = 900
const ROCKET_SIZE = 32
export (int) var DISTANCE_PER_SECOND = 16
onready var SPEED = ROCKET_SIZE * DISTANCE_PER_SECOND
export (float) var STEERING_FORCE = 0.01

var target_point = Vector2()
var velocity : Vector2

func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	var direction_to_mouse = global_position.direction_to(mouse_pos)
	target_point = mouse_pos + Vector2(
			TARGET_OFFSET * cos(direction_to_mouse.angle()),
			TARGET_OFFSET * sin(direction_to_mouse.angle()))
	look_at(target_point)
	
	var desired_velocity = (target_point - global_position).normalized() * SPEED
	var steering_velocity = STEERING_FORCE * (desired_velocity - velocity)
	velocity = (velocity + steering_velocity).clamped(SPEED)
#	if velocity.length() > SPEED:
#		velocity /= (velocity.length() / SPEED)
	
	move_and_collide(velocity * delta)
