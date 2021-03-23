extends KinematicBody2D

signal jump_started()
signal on_floor()
signal teleported()

const FLOOR_NORMAL = Vector2.UP
const MIN_PITCH : float = 0.85
const MAX_PITCH : float = 1.15

# Physics constants
export (Curve) var jump_press_curve
export (int) var MIN_JUMP_HEIGHT = 25
export (int) var MAX_JUMP_HEIGHT = 300
export (int) var MIN_JUMP_DISTANCE = 25
export (int) var MAX_JUMP_DISTANCE = 300
const MIN_JUMP_TIME : float = 0.5 / 2
const MAX_JUMP_TIME : float = 1.5 / 2
const TIME_TO_MAX : float = 1.2 #Tempo total de carregamento do mouse até pulo máx
onready var aux_speed = 0.75*2*MAX_JUMP_DISTANCE / MIN_JUMP_TIME

# Nodes
onready var main_sprite = $Graphics/Main
onready var animation_player = $Graphics/AnimationPlayer
onready var arrow_widget = $Graphics/ArrowWidget
onready var dust_particles = $Graphics/Dust
onready var jump_sfx = $SoundEffects/Jump
onready var squash_sfx = $SoundEffects/Squash
onready var whistle_sfx = $SoundEffects/Whistle
onready var whistle_start_timer = $SoundEffects/WhistleStartTimer

# Mouse press
onready var press_timer = $PressTimer
var press_time : float = 0.0

# Trajectory variables
var target_point = Vector2()
var target_time : float = 0.0

# _input(event) mouse variables
var is_mouse_pressed : bool = false
var is_mouse_released : bool = false

var is_pressing : bool = false
var is_jumping : bool = false

onready var gravity : int = 2*MAX_JUMP_HEIGHT/(MAX_JUMP_TIME*MAX_JUMP_TIME)
var direction : int = 1
var velocity = Vector2()
var t


func _ready():
	press_timer.wait_time = TIME_TO_MAX

func teleport():
	if Input.is_action_just_pressed("teleport"):
		global_position = get_global_mouse_position()
		emit_signal("teleported")

func _process(delta):
	if is_pressing:
		arrow_widget.show_sprites()
		arrow_widget.calculate_trajectory(target_point, global_position, delta)
	else:
		arrow_widget.hide_sprites()


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
			whistle_sfx.play()
		t = (TIME_TO_MAX - press_timer.time_left) / TIME_TO_MAX
		interpolate(t)
		update()
		
		if t >= 1.0:
			start_jump(t)
	if Input.is_action_just_released("jump"):
		start_jump(t)

func interpolate(t):
	target_point.x = Easing.easeInCirc(direction * MIN_JUMP_DISTANCE, direction * MAX_JUMP_DISTANCE, t)
	target_point.y = Easing.easeInCirc(-MIN_JUMP_HEIGHT, -MAX_JUMP_HEIGHT, t)
	target_time = Easing.easeInCirc(MIN_JUMP_TIME, MAX_JUMP_TIME, t)

func curve_interpolate(t):
	target_point.x = Easing.curve(jump_press_curve, direction * MIN_JUMP_DISTANCE, direction * MAX_JUMP_DISTANCE, t)
	target_point.y = Easing.curve(jump_press_curve, -MIN_JUMP_HEIGHT, -MAX_JUMP_HEIGHT, t)
	target_time = Easing.curve(jump_press_curve, MIN_JUMP_TIME, MAX_JUMP_TIME, t)

func start_jump(t):
	is_pressing = false
	whistle_sfx.stop()
	jump_sfx.pitch_scale = Easing.easeInSine(MIN_PITCH, MAX_PITCH, t)
	jump_sfx.play()
	gravity = -2 * target_point.y / (target_time * target_time)
	velocity = Vector2(
			target_point.x / target_time,
			2 * target_point.y / target_time)
	press_timer.stop()
	emit_signal("jump_started")

func get_on_ground():
	emit_signal("on_floor")
	squash_sfx.play()

func move(delta):
	move_sliding(delta)

func move_sliding(delta):
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	velocity.y += gravity * delta
	if is_on_floor():
		get_on_ground()

func move_colliding(delta):
	velocity.y += gravity * delta
	var collision = move_and_collide(velocity * delta)
	if collision:
		var normal = collision.normal
		var dot = normal.dot(FLOOR_NORMAL)
		if dot >= 0.9:
			emit_signal("on_floor")
		if dot <= -0.9:
			velocity.y = 0
		if dot <= 0.1 and dot >= -0.1:
			velocity = Vector2(0,0)

func turn_around(dir: int):
	if dir == 1:
		main_sprite.scale.x = 1
	elif dir == -1:
		main_sprite.scale.x = -1

#func is_on_ground():
#	return is_on_floor()
