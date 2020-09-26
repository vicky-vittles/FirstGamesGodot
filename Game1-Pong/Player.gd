extends KinematicBody2D

const SCREEN_HEIGHT = 720
const SCREEN_PERCENTAGE_PER_SECOND = 0.1
const SPEED = SCREEN_HEIGHT * SCREEN_PERCENTAGE_PER_SECOND

const TIME_TO_MAX_SPEED = 0.03
const ACC = SPEED / TIME_TO_MAX_SPEED

export (int) var player_index = 1

var velocity = Vector2()
var acceleration = Vector2()


func _physics_process(delta):
	
	var min_speed = 0
	var max_speed = 0
	
	if Input.is_action_pressed("down_"+str(player_index)):
		acceleration.y = ACC
		if velocity.y < 0:
			velocity.y = 0
		min_speed = 0
		max_speed = SPEED
		
	elif Input.is_action_pressed("up_"+str(player_index)):
		acceleration.y = -ACC
		if velocity.y > 0:
			velocity.y = 0
		min_speed = -SPEED
		max_speed = 0
		
	else:
		acceleration.y = 0
		velocity.y = 0
	
	velocity.y += clamp(velocity.y + acceleration.y * delta, min_speed, max_speed)
	
	move_and_collide(velocity * delta)
