extends Area2D

const SPEED = 700

var player_index = 1
var direction = Vector2()


func shoot(p_index, ship_direction):
	$Sprite.texture = load("res://Entities/Bullet/bullet-" + str(p_index) + ".png")
	
	rotation = ship_direction.angle() + PI/2
	direction = ship_direction


func _physics_process(delta):
	position += direction * SPEED * delta
	
	if not $VisibilityNotifier2D.is_on_screen():
		if position.x > 1280:
			position.x = 0
		elif position.x < 0:
			position.x = 1280
	
		if position.y > 720:
			position.y = 0
		elif position.y < 0:
			position.y = 720


func _on_LifetimeTimer_timeout():
	get_parent().remove_child(self)
	queue_free()


func _on_Bullet_area_entered(area):
	if area.is_in_group("player") or area.is_in_group("asteroid"):
		get_parent().remove_child(self)
		queue_free()
