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

onready var character = $Character
onready var ground_ray = character.get_node("GroundRay")
onready var display = character.get_node("Display")
onready var health_bar = character.get_node("HealthBar")
onready var graphics = $Graphics
onready var hand = graphics.get_node("Hand")
onready var gun = hand.get_node("Gun")
onready var health = $Health
onready var data = $Data

onready var speed = RUN_SPEED
onready var gravity = JUMP_GRAVITY
var jump_press : bool = false
var jump_released : bool = false
var shoot_press : bool = false
var shoot_hold : bool = false
var last_direction = Vector2(1,0)
var direction : Vector2
var velocity : Vector2


func setup(_display_name: String):
	display.display_name = _display_name

func _physics_process(delta):
	if not is_network_master():
		return
	data.sync_data()

func get_input():
	if not is_network_master():
		return
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
