extends KinematicBody2D

export (int) var WALK_SPEED = 5 * 20
onready var current_speed = WALK_SPEED

onready var graphics = $Graphics

var display_name : String

var last_direction : Vector2
var direction : Vector2
var velocity : Vector2

func get_input():
	direction = Vector2.ZERO
	direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	direction = direction.normalized()
	if direction != Vector2.ZERO:
		last_direction = direction

func get_angle_to_mouse() -> float:
	return rad2deg(get_angle_to(get_global_mouse_position()))

func move(delta):
	velocity = current_speed * direction
	move_and_slide(velocity)
