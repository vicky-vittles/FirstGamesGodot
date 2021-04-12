extends KinematicBody2D

const ONE_FRAME = 1.0/60.0
const FLOOR_NORMAL = Vector2.UP
const CHAR_SIZE = 24

export (int) var RUN_SPEED = 5*CHAR_SIZE
export (int) var JUMP_HEIGHT = 4*CHAR_SIZE
export (float) var JUMP_TIME = 0.45

onready var JUMP_SPEED = -2*JUMP_HEIGHT/JUMP_TIME
onready var JUMP_GRAVITY = 2*JUMP_HEIGHT/(JUMP_TIME*JUMP_TIME)

onready var graphics = $Graphics

onready var speed = RUN_SPEED
onready var gravity = JUMP_GRAVITY
var jump_press : bool = false
var jump_released : bool = false
var direction : Vector2
var velocity : Vector2


func get_input():
	direction = Vector2.ZERO
	direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	jump_press = Input.is_action_pressed("jump")
	jump_released = Input.is_action_just_released("jump")

func apply_speed():
	velocity.x = speed * direction.x

func apply_gravity(delta):
	velocity.y += gravity * delta

func move(delta):
	velocity = move_and_slide(velocity, FLOOR_NORMAL)

func is_on_ground() -> bool:
	return is_on_floor()
