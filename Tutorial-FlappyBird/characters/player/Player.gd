extends RigidBody2D

class_name Player

signal die

onready var wing_sfx = $Wing
onready var hit_sfx = $Hit

export (int) var FLAP_FORCE = -340
const MAX_ROTATION_DEGREES = -30.0
var started = false
var is_alive = true

func start():
	if started: return
	
	started = true
	gravity_scale = 10.0
	$AnimationPlayer.play("flap")

func _physics_process(_delta):
	if Input.is_action_just_pressed("flap") and is_alive:
		if not started:
			start()
		flap()
	
	if rotation_degrees <= MAX_ROTATION_DEGREES:
		angular_velocity = 0
		rotation_degrees = MAX_ROTATION_DEGREES
	
	if linear_velocity.y > 0:
		if rotation_degrees <= 90.0:
			angular_velocity = 8.0
		else:
			angular_velocity = 0.0

func flap():
	linear_velocity.y = FLAP_FORCE
	angular_velocity = -20.0
	wing_sfx.play()

func die():
	if not is_alive: return
	
	is_alive = false
	hit_sfx.play()
	emit_signal("die")
	$AnimationPlayer.stop()
