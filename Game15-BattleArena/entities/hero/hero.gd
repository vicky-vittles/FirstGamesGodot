extends KinematicBody2D

signal get_hurt(source)

const ONE_FRAME = 1.0/60.0
const FLOOR_NORMAL = Vector2.UP
const CHAR_SIZE = 24

export (int) var RUN_SPEED = 5*CHAR_SIZE
export (int) var JUMP_HEIGHT = 3*CHAR_SIZE
export (float) var JUMP_TIME = 0.4

onready var JUMP_SPEED = -2*JUMP_HEIGHT/JUMP_TIME
onready var JUMP_GRAVITY = 2*JUMP_HEIGHT/(JUMP_TIME*JUMP_TIME)

onready var ground_ray = $Character/GroundRay
onready var graphics = $Graphics
onready var health = $Health
onready var hand = $Graphics/Hand
onready var gun = hand.get_node("Gun")

onready var speed = RUN_SPEED
onready var gravity = JUMP_GRAVITY
var jump_press : bool = false
var jump_released : bool = false
var shoot_press : bool = false
var shoot_hold : bool = false
var last_direction = Vector2(1,0)
var direction : Vector2
var velocity : Vector2


func get_input():
	direction = Vector2.ZERO
	direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	if direction != Vector2.ZERO:
		last_direction = direction
	jump_press = Input.is_action_just_pressed("jump")
	jump_released = Input.is_action_just_released("jump")
	shoot_press = Input.is_action_just_pressed("shoot")
	shoot_hold = Input.is_action_pressed("shoot")

func hurt(damage, source):
	if source.is_in_group("bullet"):
		health.hurt(damage)
		emit_signal("get_hurt", source)

func check_shoot():
	if shoot_hold:
		gun.shoot(last_direction, [self])

func apply_speed():
	velocity.x = speed * direction.x

func apply_gravity(delta):
	velocity.y += gravity * delta

func apply_impulse(impulse):
	velocity = impulse

func move(delta):
	velocity = move_and_slide(velocity, FLOOR_NORMAL)

func is_on_ground() -> bool:
	return ground_ray.is_colliding() or is_on_floor()
