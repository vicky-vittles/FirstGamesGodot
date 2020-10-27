extends KinematicBody2D

class_name Enemy

const TILE_SIZE = 16
export (int) var HORIZONTAL_DISTANCE_IN_ONE_SECOND = 6
onready var SPEED = TILE_SIZE * HORIZONTAL_DISTANCE_IN_ONE_SECOND

var nearest_player
export (int) var player_detection_radius = 200
export (int) var attack_detection_radius = 75

var hit_direction = Vector2()
var velocity = Vector2()

var walk_direction = Vector2()
var look_direction = Vector2()
var is_attacking = false


func _ready():
	$Hurtbox.connect("area_entered", self, "_on_Hurtbox_area_entered")
	$Health.connect("update_health", self, "_on_Health_update_health")
	$Health.connect("die", self, "_on_Health_die")


func disable():
	$Sprite.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	
	for i in $Hitbox.get_child_count():
		$Hitbox.get_child(i).set_deferred("disabled", true)
	
	for i in $Hurtbox.get_child_count():
		$Hurtbox.get_child(i).set_deferred("disabled", true)
	
	$StateMachine.disable()
	
	if has_node("EquippedWeapon"):
		if $EquippedWeapon.get_child_count() > 0:
			$EquippedWeapon.get_child(0).disable()


func poll_input():
	nearest_player = get_nearest_player()
	
	if nearest_player != null:
		var dist_to_p = global_position.distance_to(nearest_player.global_position)
		
		look_direction = (nearest_player.global_position - global_position).normalized()
		is_attacking = true if dist_to_p <= attack_detection_radius else false


func get_nearest_player():
	var nearest_player_index = null
	var smallest_distance = INF
	
	for i in range(1,3):
		var player = get_node("../../Players/Player" + str(i))
		
		var distance_to_player = player.global_position.distance_to(global_position)
		
		if distance_to_player < smallest_distance and distance_to_player <= player_detection_radius:
			smallest_distance = distance_to_player
			nearest_player_index = i
	
	if nearest_player_index != null:
		return get_node("../../Players/Player" + str(nearest_player_index))
	else:
		return null


func turn_around(direction):
	if direction == 1:
		$Sprite.flip_h = false
		$CollisionShape2D.position.x = abs($CollisionShape2D.position.x)
		$Hitbox.position.x = abs($Hitbox.position.x)
		$Hurtbox.position.x = abs($Hurtbox.position.x)
	elif direction == -1:
		$Sprite.flip_h = true
		$CollisionShape2D.position.x = -1 * abs($CollisionShape2D.position.x)
		$Hitbox.position.x = -1 * abs($Hitbox.position.x)
		$Hurtbox.position.x = -1 * abs($Hurtbox.position.x)


func _on_Hurtbox_area_entered(area):
	if area.is_in_group("player_attack"):
		$Health.update_health(-area.damage)


func _on_Health_update_health(new_amount):
	if new_amount > 0:
		$Grunt.play()


func _on_Health_die():
	disable()
	$DeathTimer.start()
	$Die.play()


func _on_DeathTimer_timeout():
	queue_free()
