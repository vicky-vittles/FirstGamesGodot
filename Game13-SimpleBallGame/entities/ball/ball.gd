extends RigidBody

export (float) var run_speed = 5
export (float) var jump_speed = 10

onready var feet_ray = $FeetRay

var jump : bool = false
var direction = Vector3()
var velocity = Vector3()

func _process(_delta):
	direction.z = int(Input.is_action_pressed("move_backward")) - int(Input.is_action_pressed("move_forward"))
	direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	direction = direction.normalized()
	jump = Input.is_action_just_pressed("jump")

func _integrate_forces(state): 
	add_central_force(run_speed * direction)
	if jump and feet_ray.is_colliding():
		apply_central_impulse(jump_speed * Vector3.UP)
