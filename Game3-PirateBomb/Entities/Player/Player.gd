extends KinematicBody2D

class_name Player

signal bomb_exploded(player_index)

const BOMB = preload("res://Entities/Bomb/Bomb.tscn")

const ONE_FRAME = 0.0166
const TILE_SIZE = 32
const PLAYER_HEIGHT = 50

const DISTANCE_IN_ONE_SECOND = 6 * TILE_SIZE
const RUN_SPEED = DISTANCE_IN_ONE_SECOND

const JUMP_HEIGHT = 2.5 * PLAYER_HEIGHT
const JUMP_ASCENT_TIME = 18 * ONE_FRAME
const JUMP_ASCENT_GRAVITY = 2 * JUMP_HEIGHT / (JUMP_ASCENT_TIME * JUMP_ASCENT_TIME)
const JUMP_ASCENT_SPEED = -2 * JUMP_HEIGHT / JUMP_ASCENT_TIME
const JUMP_DESCENT_TIME = 13 * ONE_FRAME
const JUMP_DESCENT_GRAVITY = 2 * JUMP_HEIGHT / (JUMP_DESCENT_TIME * JUMP_DESCENT_TIME)

const KNOCKBACK_DISTANCE_IN_ONE_SECOND = 3 * TILE_SIZE
const KNOCKBACK_HEIGHT = 1.5 * TILE_SIZE
const KNOCKBACK_HEIGHT_TIME = 16 * ONE_FRAME
const KNOCKBACK_GRAVITY = 2 * KNOCKBACK_HEIGHT / (KNOCKBACK_HEIGHT_TIME * KNOCKBACK_HEIGHT_TIME)
const KNOCKBACK_SPEED = Vector2(KNOCKBACK_DISTANCE_IN_ONE_SECOND / KNOCKBACK_HEIGHT_TIME, -2 * KNOCKBACK_HEIGHT / KNOCKBACK_HEIGHT_TIME)

onready var character = $Character
onready var bombs = $Bombs
onready var collision_shape = get_node("CollisionShape2D")
onready var collision_shape_2 = get_node("CollisionShape2D2")

onready var animated_sprite = character.get_node("AnimatedSprite")
onready var hurtbox = character.get_node("Hurtbox")
onready var punch_hitbox = character.get_node("PunchHitbox")
onready var punch_hitbox_shape = character.get_node("PunchHitbox/CollisionShape2D")
onready var door_hitbox = character.get_node("DoorHitbox")
onready var health = character.get_node("Health")
onready var steps_on_wood_sfx = character.get_node("StepsOnWoodSFX")

onready var bomb_bar = bombs.get_node("BombBar")
onready var bomb_cooldown_timer = bombs.get_node("BombCooldownTimer")
onready var tween = bombs.get_node("BombTween")
onready var bomb_spawn = bombs.get_node("BombSpawn")
onready var bomb_placed_sfx = bombs.get_node("BombPlaceSFX")
onready var bomb_swish_sfx = bombs.get_node("BombSwishSFX")

var bar_progress = 0
var max_bombs = 4
var bombs_left = max_bombs
var can_place_bombs = true

var door
var can_enter_doors = false

export (int) var player_index = 1

var left : bool = false
var right : bool = false
var up : bool = false
var attack : bool = false
var jump : bool = false

var velocity = Vector2()
var acceleration = Vector2()


func _ready():
	punch_hitbox_shape.set_deferred("disabled", true)


func get_input():
	
	left = Input.is_action_pressed("left_" + str(player_index))
	right = Input.is_action_pressed("right_" + str(player_index))
	up = Input.is_action_pressed("up_" + str(player_index))
	jump = Input.is_action_just_pressed("jump_" + str(player_index))
	attack = Input.is_action_just_pressed("bomb_" + str(player_index))
	
	if left and right:
		left = false
		right = false


func move_y(delta):
	velocity.y += acceleration.y * delta
	velocity = move_and_slide(velocity, Vector2.UP)


func place_bomb():
	
	if can_place_bombs and bombs_left > 0:
		
		can_place_bombs = false
		bombs_left = bombs_left - 1
	
		randomize()
		bomb_placed_sfx.pitch_scale = rand_range(0.8, 1)
		bomb_placed_sfx.play()
		
		var bomb = BOMB.instance()
		
		bomb.position = bomb_spawn.global_position
		
		$"../Bombs".add_child(bomb)
		
		bomb.connect("exploded", self, "_on_Bomb_explosion")
		
		bomb_bar.show()
		
		bar_progress = 0
		tween.interpolate_property(self, "bar_progress", 0, 100, bomb_cooldown_timer.wait_time)
		
		if not tween.is_active():
			tween.start()
		
		bomb_cooldown_timer.start()


func _physics_process(delta):
	bomb_bar.get_node("BarFill").value = bar_progress


func turn_around(direction):
	if direction == 1:
		animated_sprite.flip_h = false
		hurtbox.position.x = abs(hurtbox.position.x)
		punch_hitbox.position.x = abs(punch_hitbox.position.x)
		door_hitbox.position.x = abs(door_hitbox.position.x)
		collision_shape.position.x = abs(collision_shape.position.x)
		collision_shape_2.position.x = abs(collision_shape_2.position.x)
		
	elif direction == -1:
		animated_sprite.flip_h = true
		hurtbox.position.x = -1 * abs(hurtbox.position.x)
		punch_hitbox.position.x = -1 * abs(punch_hitbox.position.x)
		door_hitbox.position.x = -1 * abs(door_hitbox.position.x)
		collision_shape.position.x = -1 * abs(collision_shape.position.x)
		collision_shape_2.position.x = -1 * abs(collision_shape_2.position.x)


func _on_DoorHitbox_area_entered(area):
	if area.is_in_group("door"):
		door = (area as Door)
		can_enter_doors = true


func _on_DoorHitbox_area_exited(area):
	if area.is_in_group("door"):
		door = null
		can_enter_doors = false


func _on_BombCooldownTimer_timeout():
	can_place_bombs = true
	bomb_bar.hide()


func _on_Bomb_explosion():
	bombs_left = bombs_left + 1
	emit_signal("bomb_exploded", player_index)
