extends "res://Entities/Ship/Player/States/PlayerFly.gd"

onready var random_direction_timer = $RandomDirectionTimer

var direction_to_escape = Vector2()
var escaping_bullet : bool = false
var turning_around_randomly : bool = false
var random_direction : int


func _ready():
	randomize()


func process(_delta):
	
	ship.input_left_hold = false
	ship.input_right_hold = false
	ship.input_fire = false
	
	if escaping_bullet:
		var a1 = rad2deg(direction_to_escape.angle_to(ship.direction))
		var a2 = 360 - abs(a1)
		
		var smallest_angle = min(abs(a1), a2)
		
		if sign(a1) == 1:
			ship.input_right_hold = true
		elif sign(a1) == -1:
			ship.input_left_hold = true
		
		if smallest_angle < 1:
			escaping_bullet = false
			direction_to_escape = Vector2.ZERO
	
	else:
		var rand = randi() % 100
		
		if rand < 2:
			ship.input_fire = true
		
		if not turning_around_randomly:
		
			if rand % 5 == 0:
				turning_around_randomly = true
				random_direction_timer.start()
				
				random_direction = 1
				
			elif rand % 5 == 1:
				turning_around_randomly = true
				random_direction_timer.start()
				
				random_direction = -1
				
			else:
				random_direction = 0
		
		if random_direction == 1:
			ship.input_right_hold = true
		elif random_direction == -1:
			ship.input_left_hold = true


func physics_process(_delta):
	ship.move(_delta)
	
	#ship.update_fire_range()
	
	if ship.fire_range.is_colliding():
		ship.input_fire = true
	
	if ship.input_fire and ship.can_fire:
		ship.can_fire = false
		ship.fire_delay.start()
		
		ship.fire()


func _on_BulletDetector_area_entered(area):
	if fsm.current_state == self and area.is_in_group("bullet"):
		
		var bullet_dir = area.direction
		direction_to_escape = ship.direction - bullet_dir * bullet_dir.dot(ship.direction)
		direction_to_escape = direction_to_escape.normalized()
		
		escaping_bullet = true

func _on_RandomDirectionTimer_timeout():
	turning_around_randomly = false
