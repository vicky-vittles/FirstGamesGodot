extends KinematicBody2D

const FLOOR_NORMAL = Vector2.UP
const ONE_FRAME : float = float(1) / float(60)

onready var animation_player = $AnimationPlayer
onready var jump_delay_timer = $StateMachine/Jump/DelayTimer
onready var jump_ascend_timer = $StateMachine/Jump/DurationTimer
onready var jump_hang_timer = $StateMachine/Hang/DurationTimer
onready var jump_descend_timer = $StateMachine/Fall/DurationTimer
onready var sprites = $Sprites
onready var physics_shape = $CollisionShape2D
onready var whip_hitbox = $Whip/CollisionShape2D

export (float) var DISTANCE_PER_SECOND : float = 62.21
export (float) var JUMP_HEIGHT : float = 32
export (float) var JUMP_ASCEND_TIME : float = 16 * ONE_FRAME
export (float) var JUMP_HANG_TIME : float = 8 * ONE_FRAME
export (float) var JUMP_DESCEND_TIME : float = 16 * ONE_FRAME
export (float) var JUMP_START_DELAY : float = 3 * ONE_FRAME

onready var MOVE_SPEED : float = DISTANCE_PER_SECOND
onready var JUMP_ASCEND_GRAVITY : float = Formulas.calculate_gravity(JUMP_HEIGHT, JUMP_ASCEND_TIME)
onready var JUMP_ASCEND_SPEED : float = Formulas.calculate_speed(JUMP_HEIGHT, JUMP_ASCEND_TIME)
onready var JUMP_HANG_GRAVITY : float = 0
onready var JUMP_DESCEND_GRAVITY : float = Formulas.calculate_gravity(JUMP_HEIGHT, JUMP_DESCEND_TIME)
onready var JUMP_DESCEND_SPEED : float = Formulas.calculate_speed(JUMP_HEIGHT, JUMP_DESCEND_TIME)

var whip_level = 3

onready var gravity : float = JUMP_ASCEND_GRAVITY
var direction : int = 0
var last_direction : int
var velocity = Vector2()
var input_jump : bool
var input_up : bool
var input_down : bool
var input_attack : bool


func _ready():
	jump_delay_timer.wait_time = JUMP_START_DELAY
	jump_ascend_timer.wait_time = JUMP_ASCEND_TIME
	jump_hang_timer.wait_time = JUMP_HANG_TIME
	jump_descend_timer.wait_time = JUMP_DESCEND_TIME


func _process(delta):
	pass


func _physics_process(delta):
	pass


func get_input():
	direction = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
	
	if direction != 0:
		last_direction = direction
	
	input_up = Input.is_action_pressed("up")
	input_down = Input.is_action_pressed("down")
	input_jump = Input.is_action_just_pressed("jump")
	input_attack = Input.is_action_just_pressed("attack")


func move(delta):
	velocity.x = direction * MOVE_SPEED
	
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	
	velocity.y += gravity * delta


func flip(direction):
	if direction == 1:
		sprites.scale.x = -1
		physics_shape.position.x = abs(physics_shape.position.x)
		whip_hitbox.position.x = abs(whip_hitbox.position.x)
	
	elif direction == -1:
		sprites.scale.x = 1
		physics_shape.position.x = -abs(physics_shape.position.x)
		whip_hitbox.position.x = -abs(whip_hitbox.position.x)
