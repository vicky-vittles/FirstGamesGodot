extends KinematicBody2D

const SCREEN_WIDTH = 1280
const SCREEN_PERCENTAGE_IN_ONE_SECOND = 0.13
const SPEED = SCREEN_WIDTH * SCREEN_PERCENTAGE_IN_ONE_SECOND
const ADDITIONAL_SPEED = 0.033 * SCREEN_WIDTH

var hit_counter = 0
var max_hits = 3

var initial_direction = Vector2(1, 0)
var direction = Vector2()


func _ready():
	random_direction()


func _physics_process(delta):
	
	var velocity = direction * (SPEED + hit_counter * ADDITIONAL_SPEED)
	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		
		if collision_info.collider.is_in_group("walls"):
			direction = direction.bounce(collision_info.normal)
			hit_counter = max(0, hit_counter - 0.2)
			
		elif collision_info.collider.is_in_group("paddles"):
			direction = direction.bounce(collision_info.normal)
			var y = direction.y/2 + collision_info.collider_velocity.normalized().y
			direction = Vector2(direction.x ,y).normalized()
			
			hit_counter = min(max_hits, hit_counter + 1)


func random_direction():
	randomize()
	var rand_angle = (randf() * 2*PI/3) - PI/3
	
	direction = initial_direction.rotated(rand_angle)
	direction.x = (randi() & 2) - 1
	
	direction = direction.normalized()
