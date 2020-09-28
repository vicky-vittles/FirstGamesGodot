extends KinematicBody2D

class_name Player

signal update_health(player_index, new_amount)
signal player_died(player_index)
signal screen_exited(player_index)
signal screen_entered(player_index)

const SCREEN_WIDTH = 1280
const SCREEN_WIDTH_PERCENTAGE = 0.3
const SPEED = SCREEN_WIDTH * SCREEN_WIDTH_PERCENTAGE
const ROTATION_SPEED = PI

enum STATES {SPAWN, FLY, DEAD, HIDDEN}
var current_state = STATES.SPAWN

const BULLET = preload("res://Entities/Bullet/Bullet.tscn")
export (int) var player_index = 1

var direction = Vector2(0, -1)


func _ready():
	$"..".connect("game_started", self, "_on_World_game_started")
	$"..".connect("game_won", self, "_on_World_game_won")
	$Health.connect("update_health", self, "_on_Health_update_health")
	$Health.connect("died", self, "_on_Health_died")
	
	$Sprite.texture = load("res://Entities/Player/player-spaceship-"+str(player_index)+".png")
	
	$Particles2D.texture = load("res://Entities/Player/explosion-"+str(player_index)+".png")


func _physics_process(delta):
	
	if current_state == STATES.FLY:
	
		if Input.is_action_just_pressed("left_" + str(player_index)):
			if not $MovementAnimations.is_playing():
				$MovementAnimations.play("turn")
		elif Input.is_action_just_pressed("right_" + str(player_index)):
			if not $MovementAnimations.is_playing():
				$MovementAnimations.play("turn")
		
		if Input.is_action_pressed("left_" + str(player_index)):
			direction = direction.rotated(-ROTATION_SPEED*delta)
			$Sprite.flip_h = false
			$WhiteSprite.flip_h = false
			
		elif Input.is_action_pressed("right_" + str(player_index)):
			direction = direction.rotated(ROTATION_SPEED*delta)
			$Sprite.flip_h = true
			$WhiteSprite.flip_h = true
			
		else:
			if $Sprite.frame != 0 and not $MovementAnimations.is_playing():
				$MovementAnimations.play("go_to_idle")
		
		rotation = direction.angle() + PI/2
		
		if Input.is_action_just_pressed("shoot_" + str(player_index)):
			$LaserShootSFX.play_random()
			
			var bullet = BULLET.instance()
			bullet.position = $BulletSpawn.global_position
			bullet.shoot(player_index, direction)
			
			$"../Bullets".add_child(bullet)
		
		var collision = move_and_collide(direction * SPEED * delta)
		if collision:
			if collision.collider.is_in_group("asteroid"):
				direction = direction.bounce(collision.normal)
				rotation = direction.angle() + PI/2
	
	elif current_state == STATES.DEAD:
		if not $DamageAnimations.is_playing():
			$DamageAnimations.play("died")
	
	if not $VisibilityNotifier2D.is_on_screen():
		if position.x > 1280:
			position.x = 0
		elif position.x < 0:
			position.x = 1280
	
		if position.y > 720:
			position.y = 0
		elif position.y < 0:
			position.y = 720


func _on_Hurtbox_area_entered(area):
	if (area.is_in_group("bullet") or area.is_in_group("asteroid")) and current_state != STATES.DEAD:
		$Health.take_damage(5)
		$HurtSFX.play_random()
		$DamageAnimations.play("take_damage")


func _on_Health_update_health(new_amount):
	emit_signal("update_health", player_index, new_amount)


func _on_Health_died():
	current_state = STATES.DEAD
	$CollisionPolygon2D.set_deferred("disabled", true)
	$Hurtbox/CollisionPolygon2D.set_deferred("disabled", true)
	$DeadTimer.start()
	$Particles2D.emitting = true
	
	emit_signal("player_died", player_index)


func _on_DeadTimer_timeout():
	current_state = STATES.HIDDEN
	$Particles2D.emitting = false


func _on_World_game_started():
	current_state = STATES.FLY


func _on_World_game_won(player_victory):
	if player_index == player_victory:
		current_state = STATES.SPAWN
		$CollisionPolygon2D.set_deferred("disabled", true)
		$Hurtbox/CollisionPolygon2D.set_deferred("disabled", true)


func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("screen_exited", player_index)


func _on_VisibilityNotifier2D_screen_entered():
	emit_signal("screen_entered", player_index)
