extends KinematicBody

export (Color) var color
export (float) var invisibility = 0.0
export (float) var mouse_sensitivity = 0.5
export (bool) var is_player = true

export (bool) var can_attack = false

onready var input = $Controller
onready var head = $Head
onready var camera = $Camera
onready var graphics = $Graphics
onready var character_mover = $CharacterMover
onready var animation_player = $AnimationPlayer

var is_crouching : bool = false
var move_direction : Vector3

func _ready():
	graphics.set_transparent(1.0 - invisibility)
	graphics.change_color(color)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if not is_player:
		graphics.visible = true

func event_input(event):
	if event is InputEventMouseMotion:
		if is_player:
			rotation_degrees.y -= mouse_sensitivity * event.relative.x
			camera.rotation_degrees.x -= mouse_sensitivity * event.relative.y
			camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)

func get_input():
	input.clear_input()
	move_direction = Vector3.ZERO
	if input:
		input.get_input()
		move_direction += Vector3.FORWARD * int(input.get_hold("move_forward"))
		move_direction += Vector3.BACK * int(input.get_hold("move_backward"))
		move_direction += Vector3.LEFT * int(input.get_hold("move_left"))
		move_direction += Vector3.RIGHT * int(input.get_hold("move_right"))

func hurt():
	animation_player.play("die")

func check_walk():
	if input.get_hold("walk") or (not input.get_hold("walk") and is_crouching):
		character_mover.set_slow_speed()
	else:
		character_mover.set_run_speed()

func check_crouch():
	if input.get_press("crouch") and not head.is_colliding:
		is_crouching = !is_crouching
		if is_crouching:
			character_mover.set_slow_speed()
			animation_player.play("crouch")
		else:
			character_mover.set_run_speed()
			animation_player.play("stand_up")

func air_movement(delta):
	character_mover.set_movement_direction(move_direction)
	character_mover.apply_acceleration(delta)
	character_mover.move(delta)

func full_movement(delta):
	character_mover.set_movement_direction(move_direction)
	character_mover.apply_acceleration(delta)
	character_mover.apply_speed(delta)
	character_mover.move(delta)
