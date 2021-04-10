extends KinematicBody2D

signal update_placement()

var wheel_base : int = 35 # Distance between front/rear wheels
export (float) var steering_angle = 9 # Max angle of steering

export (int) var engine_power = 500 # Acceleration
export (int) var braking = -400 # Braking deceleration
export (int) var max_speed_reverse = 400 # Max speed backwards/on reverse

export (float) var friction = -0.1 # Friction to the ground
var drag : float = -0.00015 # Drag

export (int) var slip_speed = 400 # Speed where traction is reduced
export (float) var traction_fast = 0.2 # High-speed traction
export (float) var traction_slow = 0.7 # Low-speed traction

var steer_angle : float = 0.0
var velocity = Vector2()
var acceleration = Vector2()

var current_lap : int = 0
var current_point : int = 0
var can_move : bool = false

var player_name : String

onready var camera = $Camera2D
onready var graphics = $Graphics


func completed_checkpoint(id: int):
	if (current_point != (id-1)):
		return
	current_point = id
	if current_point == Globals.NUMBER_OF_CHECKPOINTS:
		current_point = 0
		completed_next_lap()
	emit_signal("update_placement")

func completed_next_lap():
	current_lap += 1


func _process(delta):
	if not can_move:
		return
	if not is_network_master():
		return
	if Input.is_action_just_pressed("change_type"):
		var type = (graphics.car_type+1)%5
		graphics.set_car_attributes(graphics.car_color, type)
	if Input.is_action_just_pressed("change_color"):
		var color = (graphics.car_color+5)%25
		graphics.set_car_attributes(color, graphics.car_type)

func _physics_process(delta):
	if not can_move:
		return
	if not is_network_master():
		return
	camera.current = true
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	velocity = move_and_slide(velocity)
	rpc_unreliable("update_info", {
		"player_name": Network.my_name,
		"position": global_position,
		"rotation": global_rotation,
		"color": graphics.car_color,
		"type": graphics.car_type
	})

master func get_input():
	var turn = 0
	turn += int(Input.is_action_pressed("steer_right"))
	turn -= int(Input.is_action_pressed("steer_left"))
	steer_angle = turn * deg2rad(steering_angle)
	
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * braking
	if Input.is_action_pressed("accel"):
		acceleration = transform.x * engine_power

puppet func update_info(new_info):
	player_name = new_info["player_name"]
	global_position = new_info["position"]
	global_rotation = new_info["rotation"]
	graphics.set_car_attributes(new_info["color"], new_info["type"])


func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acceleration += friction_force + drag_force

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_angle) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
		velocity = new_heading * velocity.length()
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()


func _on_Game_game_started():
	can_move = true
