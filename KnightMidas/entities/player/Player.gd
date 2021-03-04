extends KinematicBody2D

const FLOOR_NORMAL = Vector2.UP
const PLAYER_WIDTH = 10
const PLAYER_HEIGHT = 16
export (int) var DISTANCE_PER_SECOND = 8
onready var SPEED = DISTANCE_PER_SECOND * PLAYER_WIDTH

export (float) var JUMP_HEIGHT = 4
onready var TOTAL_JUMP_HEIGHT = JUMP_HEIGHT * PLAYER_HEIGHT
export (float) var HALF_JUMP_TIME = 0.45
onready var JUMP_SPEED = -2 * TOTAL_JUMP_HEIGHT / HALF_JUMP_TIME
onready var GRAVITY = 2 * (TOTAL_JUMP_HEIGHT) / (HALF_JUMP_TIME * HALF_JUMP_TIME)

onready var graphics = $Graphics
onready var animation_player = $Graphics/AnimationPlayer

var walk_direction : Vector2
var jump_press : bool
var jump_hold : bool
var attack_press : bool

var velocity : Vector2


func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()


func get_input():
	walk_direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	jump_press = Input.is_action_just_pressed("jump")
	jump_hold = Input.is_action_pressed("jump")
	attack_press = Input.is_action_just_pressed("attack")


func facing(direction: int):
	if direction == 1:
		graphics.scale.x = 1
	elif direction == -1:
		graphics.scale.x = -1

func apply_speed(direction: int, speed: int):
	velocity.x = direction * speed

func apply_gravity(delta):
	velocity.y += GRAVITY * delta

func move():
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
