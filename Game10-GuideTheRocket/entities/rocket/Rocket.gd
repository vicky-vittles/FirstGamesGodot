extends KinematicBody2D

signal spawn()
signal explode()

const TARGET_OFFSET = 900
const ROCKET_SIZE = 32
export (int) var MIN_DISTANCE_PER_SECOND = 8
export (int) var MAX_DISTANCE_PER_SECOND = 16
onready var MIN_SPEED = ROCKET_SIZE * MIN_DISTANCE_PER_SECOND
onready var MAX_SPEED = ROCKET_SIZE * MAX_DISTANCE_PER_SECOND
export (float) var STEERING_FORCE = 0.01

onready var collision_shape = $CollisionShape
onready var hitbox_collision_shape = $Hitbox/CollisionShape
onready var explosion = $Graphics/Explosion
onready var animation_player = $Graphics/AnimationPlayer
onready var particles = $Graphics/Particles2D

onready var spawn_pos = global_position
var target_point = Vector2()
var velocity : Vector2

func set_target():
	var mouse_pos = get_global_mouse_position()
	var direction_to_mouse = global_position.direction_to(mouse_pos)
	target_point = mouse_pos + Vector2(
			TARGET_OFFSET * cos(direction_to_mouse.angle()),
			TARGET_OFFSET * sin(direction_to_mouse.angle()))
	look_at(target_point)

func move(delta):
	var desired_velocity = (target_point - global_position).normalized() * MAX_SPEED
	var steering_velocity = STEERING_FORCE * (desired_velocity - velocity)
	velocity = (velocity + steering_velocity).clamped(MAX_SPEED)
	
	move_and_collide(velocity * delta)
	wrap_position()
	lerp_particles()

func wrap_position():
	if global_position.x > Globals.display_size.x:
		global_position.x = 0
	elif global_position.x < 0:
		global_position.x = Globals.display_size.x
	
	if global_position.y > Globals.display_size.y:
		global_position.y = 0
	elif global_position.y < 0:
		global_position.y = Globals.display_size.y

func lerp_particles():
	var velocity_percent = velocity.length()/(MAX_SPEED-MIN_SPEED)
	var lifetime = lerp(0.75, 1.5, velocity_percent)
	var scale = lerp(0.3, 0.7, velocity_percent)
	particles.lifetime = lifetime
	particles.scale_amount = scale

func spawn():
	emit_signal("spawn")

func explode():
	animation_player.play("explode")
	collision_shape.disabled = true
	hitbox_collision_shape.disabled = true
	emit_signal("explode")

func _on_Hitbox_body_entered(body):
	if body.is_in_group("terrain"):
		explode()
