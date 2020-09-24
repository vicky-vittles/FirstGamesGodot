extends KinematicBody2D

const SCREEN_HEIGHT = 720
const SCREEN_PERCENTAGE_PER_SECOND = 0.25
const SPEED = SCREEN_HEIGHT * SCREEN_PERCENTAGE_PER_SECOND

export (int) var player_index = 1

var velocity = Vector2()

func _physics_process(delta):
	
	if Input.is_action_pressed("down_"+str(player_index)):
		velocity.y = SPEED
	elif Input.is_action_pressed("up_"+str(player_index)):
		velocity.y = -SPEED
	else:
		velocity.y = 0
	
	move_and_collide(velocity * delta)
