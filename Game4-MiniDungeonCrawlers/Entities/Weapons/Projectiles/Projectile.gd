extends Area2D

class_name Projectile

export (int) var projectile_distance = 210
onready var projectile_lifetime = $LifeTimer.wait_time
onready var SPEED = projectile_distance / projectile_lifetime

var direction = Vector2()
var velocity = Vector2()

func _ready():
	$LifeTimer.start()

func _physics_process(delta):
	
	velocity = direction * SPEED * delta
	
	global_translate(velocity)

func _on_LifeTimer_timeout():
	get_parent().remove_child(self)
	queue_free()
