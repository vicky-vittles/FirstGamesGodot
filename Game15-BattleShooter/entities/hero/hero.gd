extends KinematicBody2D

export (int) var WALK_SPEED = 5 * 20
onready var current_speed = WALK_SPEED

onready var graphics = $Graphics

var display_name : String

var shoot : bool = false
var direction : Vector2
var velocity : Vector2

func get_input():
	direction = Vector2.ZERO
	direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	direction = direction.normalized()
	shoot = Input.is_action_pressed("shoot")

func get_direction_to_mouse() -> Vector2:
	return global_position.direction_to(get_global_mouse_position())

func get_angle_to_mouse() -> float:
	var dir = get_direction_to_mouse()
	return rad2deg(dir.angle())

func move(delta):
	velocity = current_speed * direction
	move_and_slide(velocity)

func shoot_gun():
	var gun = get_node("Graphics/Hand/Gun")
	gun.fire(get_direction_to_mouse())
