extends KinematicBody2D

signal jump_started()
signal on_floor()

const FLOOR_NORMAL = Vector2.UP

# Physics constants
export (int) var MAX_JUMP_HEIGHT = 350
export (int) var MAX_JUMP_DISTANCE = 350
const MIN_JUMP_TIME : float = 0.5 / 2
const MAX_JUMP_TIME : float = 1.5 / 2
const TIME_TO_MAX : float = 2.0

# Nodes
onready var main_sprite = $Graphics/Main

# Mouse press
onready var press_timer = $PressTimer
var press_time : float = 0.0

# Trajectory variables
var target_point = Vector2()
var target_time : float = 0.0

var is_jumping : bool = false

onready var gravity : int = 2*MAX_JUMP_HEIGHT/(MAX_JUMP_TIME*MAX_JUMP_TIME)
var direction : int = 1
var velocity = Vector2()


func _ready():
	press_timer.wait_time = TIME_TO_MAX

func _draw():
	draw_circle(target_point, 5.0, Color.blue)


func prepare_jump():
	if Input.is_action_pressed("jump"):
		if press_timer.is_stopped():
			press_timer.start()
		var relative_mouse_pos = get_global_mouse_position() - global_position
		var t = (TIME_TO_MAX - press_timer.time_left) / TIME_TO_MAX
		
		direction = 1 if sign(relative_mouse_pos.x) >= 0 else -1
		target_point.x = lerp(0, direction * MAX_JUMP_DISTANCE, t)
		target_point.y = lerp(0, -MAX_JUMP_HEIGHT, t)
		target_time = lerp(MIN_JUMP_TIME, MAX_JUMP_TIME, t)
		update()
	if Input.is_action_just_released("jump"):
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
