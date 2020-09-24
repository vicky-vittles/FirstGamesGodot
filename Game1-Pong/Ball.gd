extends KinematicBody2D

const SCREEN_WIDTH = 1280
const SCREEN_PERCENTAGE_IN_ONE_SECOND = 0.15
const SPEED = SCREEN_WIDTH * SCREEN_PERCENTAGE_IN_ONE_SECOND

var direction = Vector2()
var velocity = Vector2()


func _ready():
	direction.x = randf()*2.0 - 1
	direction.y = randf()*2.0 - 1
	
	direction = direction.normalized()

func _physics_process(delta):
	
	velocity = direction * SPEED
	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		
		var normal = collision_info.normal
		normal.x = round(normal.x)
		normal.y = round(normal.y)
		
		if normal.x != 0:
			direction.x *= -1
		
		if normal.y != 0:
			direction.y *= -1
		
		direction = direction.normalized()
