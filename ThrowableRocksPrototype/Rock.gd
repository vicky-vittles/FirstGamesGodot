extends KinematicBody2D

var player_height
var horizontal_distance_traveled
var time_taken_to_travel
var gravity
var initial_velocity_x

var velocity = Vector2()


func initialize(p_height, h_distance, time):
	player_height = p_height
	horizontal_distance_traveled = h_distance
	time_taken_to_travel = time
	
	gravity = 2 * player_height / (time_taken_to_travel * time_taken_to_travel)
	initial_velocity_x = horizontal_distance_traveled / time_taken_to_travel

func _physics_process(delta):
	
	velocity.x = initial_velocity_x
	velocity.y += gravity * delta
	
	move_and_collide(velocity * delta)
