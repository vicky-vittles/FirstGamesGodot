extends KinematicBody

class_name Human, "res://assets/icons/human.svg"

const NOT_Y_AXIS = Vector3(1,0,1)

export (Color) var color
export (float, 0.0, 1.0) var mouse_sensitivity = 0.5
export (bool) var is_player = true
export (bool) var ignore_rotation_on_movement = false #Move using relative or global rotation
var can_attack : bool

# Navigation and pathfinding
var nav

var brain
onready var input = $Controller
onready var fsm = $StateMachine
onready var head = $Head
onready var camera = $Camera
onready var graphics = $Graphics
onready var character_mover = $CharacterMover
onready var animation_player = $AnimationPlayer

var move_direction : Vector3

func _ready():
	if has_node("Brain"):
		brain = get_node("Brain")
	graphics.change_color(color)
	character_mover.ignore_rotation_on_movement = ignore_rotation_on_movement
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if not is_player:
		graphics.visible = true

func event_input(event):
	if not is_player:
		return
	if event is InputEventMouseMotion:
		rotation_degrees.y -= mouse_sensitivity * event.relative.x
		camera.rotation_degrees.x -= mouse_sensitivity * event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)

func get_input():
	if not is_player:
		return
	input.clear_input()
	move_direction = Vector3.ZERO
	if input:
		input.get_input()
		move_direction += Vector3.FORWARD * int(input.get_hold("move_forward"))
		move_direction += Vector3.BACK * int(input.get_hold("move_backward"))
		move_direction += Vector3.LEFT * int(input.get_hold("move_left"))
		move_direction += Vector3.RIGHT * int(input.get_hold("move_right"))

func hurt():
	animation_player.play("die")

func oriented(dir: Vector3):
	look_at(dir, Vector3.UP)

func move_to_target(target: Vector3):
	var dir = global_transform.origin.direction_to(target).normalized()
	dir *= NOT_Y_AXIS
	if dir.length() != 0:
		dir *= 1 / dir.length()
	move_direction = dir
	oriented(global_transform.origin + move_direction * NOT_Y_AXIS)

func air_movement(delta):
	character_mover.set_movement_direction(move_direction)
	character_mover.apply_acceleration(delta)
	character_mover.move(delta)

func full_movement(delta):
	character_mover.set_movement_direction(move_direction)
	character_mover.apply_acceleration(delta)
	character_mover.apply_speed(delta)
	character_mover.move(delta)
