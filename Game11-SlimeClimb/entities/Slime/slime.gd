extends KinematicBody2D

signal jump_started()
signal on_floor()

const FLOOR_NORMAL = Vector2.UP

# Physics constants
export (Curve) var jump_press_curve
export (int) var MIN_JUMP_HEIGHT = 25
export (int) var MAX_JUMP_HEIGHT = 300
export (int) var MIN_JUMP_DISTANCE = 10
export (int) var MAX_JUMP_DISTANCE = 300
const MIN_JUMP_TIME : float = 0.5 / 2
const MAX_JUMP_TIME : float = 1.5 / 2
const TIME_TO_MAX : float = 1.2 #Tempo total de carregamento do mouse até pulo máx

# Nodes
onready var main_sprite = $Graphics/Main

# Mouse press
onready var press_timer = $PressTimer
var press_time : float = 0.0

# Trajectory variables
var target_point = Vector2()
var target_time : float = 0.0

var is_pressing : bool = false
var is_jumping : bool = false

onready var gravity : int = 2*MAX_JUMP_HEIGHT/(MAX_JUMP_TIME*MAX_JUMP_TIME)
var direction : int = 1
var velocity = Vector2()


func _ready():
	press_timer.wait_time = TIME_TO_MAX

func _draw():
	draw_circle(target_point, 5.0, Color.blue)


func get_direction():
	if Input.is_action_pressed("left"):
		direction = -1
	elif Input.is_action_pressed("right"):
		direction = 1
	else:
		var relative_mouse_pos = get_global_mouse_position() - global_position
		direction = 1 if sign(relative_mouse_pos.x) >= 0 else -1

func prepare_jump():
	if Input.is_action_pressed("jump"):
		if press_timer.is_stopped() and not is_pressing:
			is_pressing = true
			press_timer.start()
		var t = (TIME_TO_MAX - press_timer.time_left) / TIME_TO_MAX
		interpolate(t)
		update()
		
		if t >= 1.0:
			start_jump()
	if Input.is_action_just_released("jump"):
		start_jump()

func interpolate(t):
	target_point.x = Easing.easeInSine(direction * MIN_JUMP_DISTANCE, direction * MAX_JUMP_DISTANCE, t)
	target_point.y = Easing.easeInSine(-MIN_JUMP_HEIGHT, -MAX_JUMP_HEIGHT, t)
	target_time = Easing.easeInSine(MIN_JUMP_TIME, MAX_JUMP_TIME, t)

func curve_interpolate(t):
	target_point.x = Easing.curve(jump_press_curve, direction * MIN_JUMP_DISTANCE, direction * MAX_JUMP_DISTANCE, t)
	target_point.y = Easing.curve(jump_press_curve, -MIN_JUMP_HEIGHT, -MAX_JUMP_HEIGHT, t)
	target_time = Easing.curve(jump_press_curve, MIN_JUMP_TIME, MAX_JUMP_TIME, t)

func start_jump():
	is_pressing = false
	gravity = -2 * target_point.y / (target_time * target_time)
	velocity = Vector2(
			target_point.x / target_time,
			2 * target_point.y / target_time)
	press_timer.stop()
	emit_signal("jump_started")

func move(delta):
	velocity.y += gravity * delta
	move_and_slide(velocity, FLOOR_NORMAL)
	if is_on_floor():
		emit_signal("on_floor")

func turn_around(dir: int):
	if dir == 1:
		main_sprite.scale.x = 1
	elif dir == -1:
		main_sprite.scale.x = -1
