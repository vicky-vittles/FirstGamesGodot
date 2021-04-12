extends Area2D

export (int) var acceleration = 100
export (int) var initial_speed = 50
export (int) var max_speed = 300
export (int) var damage = 0

onready var collision_shape = $CollisionShape

var exceptions = []
var direction = Vector2()
var velocity : Vector2

func fire(dir: Vector2):
	direction = dir
	rotation = direction.angle()
	velocity = direction * initial_speed

func _physics_process(delta):
	velocity += acceleration * direction * delta
	velocity.clamped(max_speed)
	global_position += velocity * delta


func destroy():
	queue_free()

func _on_Bullet_body_entered(body):
	if body.is_in_group("hero"):
		if not exceptions.has(body):
			body.hurt(damage)
			destroy()
	elif body.is_in_group("terrain"):
		destroy()
