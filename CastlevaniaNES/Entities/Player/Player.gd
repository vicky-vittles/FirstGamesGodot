extends KinematicBody2D

const FLOOR_NORMAL = Vector2.UP
const ONE_FRAME : float = float(1) / float(60)

onready var animation_player = $AnimationPlayer
onready var jump_ascend_timer = $StateMachine/Jump/DurationTimer
onready var jump_hang_timer = $StateMachine/Hang/DurationTimer
onready var jump_descend_timer = $StateMachine/Fall/DurationTimer
onready var sprite = $Sprite

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

onready var gravity : float = JUMP_ASCEND_GRAVITY
var direction : int = 0
var velocity = Vector2()
var input_jump : bool
var input_down : bool


func _ready():
	jump_ascend_timer.wait_time = JUMP_ASCEND_TIME
	jump_hang_timer.wait_time = JUMP_HANG_TIME
	jump_descend_timer.wait_time = JUMP_DESCEND_TIME


func _process(delta):
	pass


func _physics_process(delta):
	pass


func get_input():
	direction = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
	
	input_jump = Input.is_action_just_pressed("jump")
	input_down = Input.is_action_pressed("down")


func move(delta):
	velocity.x = direction * MOVE_SPEED
	velocity.y += gravity * delta
	
	if input_jump and is_on_floor():
		velocity.y = JUMP_ASCEND_SPEED
	
	velocity = move_and_slide(velocity, FLOOR_NORMAL)


func flip(direction):
	if direction == 1:
		sprite.flip_h = true
	elif direction == -1:
		sprite.flip_h = false
