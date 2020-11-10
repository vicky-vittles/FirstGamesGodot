extends KinematicBody2D

onready var animation_tree = $AnimationTree.get("parameters/playback")
onready var animation_player = $AnimationPlayer
onready var ground_rays = $GroundRays

var jump
var velocity = Vector2()
var last_velocity = Vector2()

export (float) var jump_height = 3*128
export (float) var jump_time = 0.5
var is_jumping = true

onready var GRAVITY = 2*jump_height/(jump_time * jump_time)
onready var JUMP_SPEED = -2*jump_height/jump_time

func _process(delta):
	jump = Input.is_action_just_pressed("jump")

func _physics_process(delta):
	
	velocity.y += GRAVITY * delta
	
	if jump and is_on_floor():
		animation_tree.travel("jump")
		is_jumping = true
		velocity.y = JUMP_SPEED
	
	if is_jumping:
		if sign(last_velocity.y) * sign(velocity.y) == -1:
			animation_tree.travel("jump")
		elif velocity.y > 0 and check_ground_raycasts():
			animation_tree.travel("fall")
	
	last_velocity = velocity
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor() and is_jumping:
		is_jumping = false

func check_ground_raycasts():
	for child in ground_rays.get_children():
		if (child as RayCast2D).is_colliding():
			return true
	return false
