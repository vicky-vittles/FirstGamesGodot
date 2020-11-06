extends KinematicBody2D

const UP = Vector2(0, -1)

var velocity = Vector2()
export var gravity = 20
export var max_velocity = 1000
export var jump_speed = -600
export var acceleration = 5
export var brake_percentage = 0.05
var is_facing_right
var brake_velocity

func _ready():
	pass

func _physics_process(delta):
	brake_velocity = brake_percentage * velocity.x
	
	velocity.y += gravity
	
	velocity.x = clamp(velocity.x, -max_velocity, max_velocity)
	
	if is_facing_right:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true
	
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	
	var is_on_floor = is_on_floor()
	
	if right or left:
		var speed = abs(velocity.x)
		
		if is_on_floor:
			if speed < 300:
				print("Walk")
			elif speed < 500:
				print("Semi Jog")
			elif speed < 700:
				print("Jog")
			elif speed < 900:
				print("Pre Run")
			elif speed < 1000:
				print("Run")
	
	if right:
		is_facing_right = true
		velocity.x += acceleration
	elif left:
		is_facing_right = false
		velocity.x -= acceleration
	else:
		velocity.x = lerp(velocity.x, 0, 0.09)
		if is_on_floor and velocity.x == 0:
			print("Idle")
	
	if is_on_floor:
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_speed
	elif !is_on_floor and velocity.y < 0:
		print("Jump")
	
	if is_on_floor and velocity.x > 0 and left:
		velocity.x -= brake_velocity
		print("Breaking")
		is_facing_right = true
		
	elif is_on_floor and velocity.x < 0 and right:
		velocity.x -= brake_velocity
		print("Breaking")
		is_facing_right = false
	
	velocity = move_and_slide(velocity, UP)
