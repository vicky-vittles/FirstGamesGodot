extends KinematicBody2D

onready var animation_player = $Body/CharacterRig/AnimationPlayer

export (int) var DISTANCE_COVERED_IN_ONE_SECOND = 500
onready var move_speed = DISTANCE_COVERED_IN_ONE_SECOND
onready var jump_speed = -550

const gravity = 1200

var is_grounded = true

var jump
var direction = Vector2()
var velocity = Vector2()


func _process(delta):
	direction.x = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
	
	if direction.x != 0:
		$Body.scale.x = sign(direction.x) * abs($Body.scale.x)
	
	jump = Input.is_action_just_pressed("jump")
	
	is_grounded = check_if_grounded()
	
	assign_animation()


func _physics_process(delta):
	velocity.x = direction.x * move_speed
	
	if jump and is_grounded:
		velocity.y = jump_speed
	
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)


func check_if_grounded():
	for raycast in $Raycasts.get_children():
		if raycast.is_colliding():
			return true
	
	return false


func assign_animation():
	var anim = "idle"
	
	if is_grounded and velocity.x != 0:
		anim = "run"
	
	animation_player.play(anim)
