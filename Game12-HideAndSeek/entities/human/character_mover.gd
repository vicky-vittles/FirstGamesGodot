extends Node

signal movement_info(body, velocity, grounded)
signal on_ground()

const FLOOR_NORMAL = Vector3.UP

export (NodePath) var body_path
onready var body : KinematicBody = get_node(body_path)

export (float) var RUN_SPEED = 100.0
export (float) var SLOW_SPEED = 6.0
export (float) var JUMP_HEIGHT = 4.0
export (float) var JUMP_TIME = 0.33
onready var JUMP_SPEED = 2*JUMP_HEIGHT/JUMP_TIME
onready var GRAVITY = -2*JUMP_HEIGHT/(JUMP_TIME*JUMP_TIME)

var ignore_rotation_on_movement : bool = false

var speed
onready var acceleration = Vector3(0, GRAVITY, 0)

var pressed_jump : bool = false
var snap = Vector3.DOWN
var movement_direction : Vector3
var velocity_air : Vector3
var velocity_ground : Vector3
var velocity : Vector3

func _ready():
	set_run_speed()

func set_slow_speed():
	speed = SLOW_SPEED

func set_run_speed():
	speed = RUN_SPEED

func set_movement_direction(_dir: Vector3):
	movement_direction = _dir.normalized()

func apply_jump(delta):
	pressed_jump = true

func apply_acceleration(delta):
	velocity_air += acceleration * delta

func apply_speed(delta):
	var current_move_direction : Vector3 = movement_direction
	if not ignore_rotation_on_movement:
		current_move_direction = current_move_direction.rotated(Vector3.UP, body.rotation.y)
	velocity_ground = current_move_direction * speed

func move(delta):
	velocity = velocity_air + velocity_ground
	velocity = body.move_and_slide_with_snap(velocity, snap, FLOOR_NORMAL)
	var grounded = body.is_on_floor()
	if grounded:
		velocity_air.y = -0.01
		emit_signal("on_ground")
	if grounded and pressed_jump:
		velocity_air.y = JUMP_SPEED
		snap = Vector3.ZERO
	else:
		snap = Vector3.DOWN
	pressed_jump = false
	emit_signal("movement_info", body, velocity, grounded)
