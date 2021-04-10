extends KinematicBody2D

export (int) var WALK_SPEED = 5 * 20
onready var current_speed = WALK_SPEED

onready var graphics = $Graphics

var display_name : String

var direction : Vector2
var velocity : Vector2

func get_input():
	direction = Vector2.ZERO
	direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	direction = direction.normalized()

func get_angle_to_mouse() -> float:
	var dir = global_position.direction_to(get_global_mouse_position())
	var angle = rad2deg(dir.angle())
	return angle

func move(delta):
	velocity = current_speed * direction
	move_and_slide(velocity)
