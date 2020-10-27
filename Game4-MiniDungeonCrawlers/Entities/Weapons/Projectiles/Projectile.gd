extends Area2D

class_name Projectile

export (int) var projectile_distance = 210
onready var projectile_lifetime = $LifeTimer.wait_time
onready var SPEED = projectile_distance / projectile_lifetime

export (int) var damage = 1
var is_alive = true

var direction = Vector2()
var velocity = Vector2()

func _ready():
	$LifeTimer.start()

func _physics_process(delta):
	
	velocity = direction * SPEED * delta
	
	global_translate(velocity)

func delete():
	if is_alive:
		is_alive = false
		get_parent().remove_child(self)
		queue_free()

func _on_LifeTimer_timeout():
	delete()

func _on_Projectile_area_entered(area):
	if area.is_in_group("enemy_hurtbox") or area.is_in_group("chest"):
		delete()

func _on_Projectile_body_entered(body):
	delete()
