extends KinematicBody2D

class_name Ship

signal game_won(player_index)
signal game_started()
signal update_health(player_index, new_amount)
signal player_died(player_index)
signal screen_exited(player_index)
signal screen_entered(player_index)

const SCREEN_WIDTH = 1280
const SCREEN_WIDTH_PERCENTAGE = 0.3
const SPEED = SCREEN_WIDTH * SCREEN_WIDTH_PERCENTAGE
const ROTATION_SPEED = PI

onready var movement_animations = $MovementAnimations
onready var damage_animations = $DamageAnimations
onready var visibility_notifier = $VisibilityNotifier2D
onready var sprite = $Sprite
onready var white_sprite = $WhiteSprite
onready var health = $Health
onready var particle_spawn = $Particles2D
onready var laser_sfx = $LaserShootSFX
onready var hurt_sfx = $HurtSFX
onready var bullet_spawn = $BulletSpawn
onready var collision_polygon = $CollisionPolygon2D
onready var hurtbox_polygon = $Hurtbox/CollisionPolygon2D

const BULLET = preload("res://Entities/Bullet/Bullet.tscn")
export (int) var player_index = 1

var input_left_press : bool = false
var input_left_hold : bool = false
var input_right_press : bool = false
var input_right_hold : bool = false
var input_fire : bool = false
var direction = Vector2(0, -1)


func _ready():
	#$"..".connect("game_started", self, "_on_World_game_started")
	#$"..".connect("game_won", self, "_on_World_game_won")
	health.connect("update_health", self, "_on_Health_update_health")
	health.connect("died", self, "_on_Health_died")
	
	sprite.texture = load("res://Entities/Ship/player-spaceship-"+str(player_index)+".png")
	
	particle_spawn.texture = load("res://Entities/Ship/explosion-"+str(player_index)+".png")


func get_input():
	var p_index = str(player_index)
	input_left_press = Input.is_action_just_pressed("left_" + p_index)
	input_left_hold = Input.is_action_pressed("left_" + p_index)
	input_right_press = Input.is_action_just_pressed("right_" + p_index)
	input_right_hold = Input.is_action_pressed("right_" + p_index)
	input_fire = Input.is_action_just_pressed("shoot_" + p_index)


func move(delta):
	
	if input_left_press:
		if not movement_animations.is_playing():
			movement_animations.play("turn")
	elif input_right_press:
		if not movement_animations.is_playing():
			movement_animations.play("turn")
	
	if input_left_hold:
		direction = direction.rotated(-ROTATION_SPEED*delta)
		sprite.flip_h = false
		white_sprite.flip_h = false
		
	elif input_right_hold:
		direction = direction.rotated(ROTATION_SPEED*delta)
		sprite.flip_h = true
		white_sprite.flip_h = true
		
	else:
		if sprite.frame != 0 and not movement_animations.is_playing():
			movement_animations.play("go_to_idle")
	
	rotation = direction.angle() + PI/2
	
	var collision = move_and_collide(direction * SPEED * delta)
	if collision:
		if collision.collider.is_in_group("asteroid"):
			direction = direction.bounce(collision.normal)
			rotation = direction.angle() + PI/2
	
	if not visibility_notifier.is_on_screen():
		wrap_around_screen()


func fire():
	laser_sfx.play_random()
	
	var bullet = BULLET.instance()
	bullet.position = bullet_spawn.global_position
	bullet.shoot(player_index, direction)
		
	$"../Bullets".add_child(bullet)


# Conexões de sinais e funções helper
func _on_Health_died():
	emit_signal("player_died", player_index)

func _on_World_game_started():
	emit_signal("game_started")

func _on_World_game_won(player_victory):
	emit_signal("game_won", player_victory)

func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("screen_exited", player_index)

func _on_VisibilityNotifier2D_screen_entered():
	emit_signal("screen_entered", player_index)

func _on_Health_update_health(new_amount):
	emit_signal("update_health", player_index, new_amount)

func wrap_around_screen():
	if position.x > 1280:
		position.x = 0
	elif position.x < 0:
		position.x = 1280
	
	if position.y > 720:
		position.y = 0
	elif position.y < 0:
		position.y = 720
