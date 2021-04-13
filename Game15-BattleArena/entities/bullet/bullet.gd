extends Area2D

export (int) var acceleration = 0
export (int) var initial_speed = 400
export (int) var max_speed = 400

var damage : int
var exceptions = []
var direction : Vector2
var velocity : Vector2

func fire(dir: Vector2):
	direction = dir
	velocity = initial_speed * direction

func _physics_process(delta):
	velocity += acceleration * direction * delta
	velocity = velocity.clamped(max_speed)
	global_position += velocity * delta


func body_entered(body):
	if body.is_in_group("hero") and not exceptions.has(body):
		if body.has_method("hurt"):
			body.hurt(damage, self)
			queue_free()

func _on_screen_exited():
	queue_free()
