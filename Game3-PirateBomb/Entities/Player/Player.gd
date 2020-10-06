extends KinematicBody2D

class_name Player

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

onready var tween = $"BombTween"
var bar_progress = 0

var max_bombs = 4
var bombs_left = max_bombs
var can_place_bombs = true
const BOMB = preload("res://Entities/Bomb/Bomb.tscn")

var door
var can_enter_doors = false

export (int) var player_index = 1

var velocity = Vector2()
var acceleration = Vector2()


func _ready():
	$PunchHitbox/CollisionShape2D.set_deferred("disabled", true)


func place_bomb():
	
	if can_place_bombs and bombs_left > 0:
		
		can_place_bombs = false
		bombs_left = bombs_left - 1
	
		randomize()
		$BombPlaceSFX.pitch_scale = rand_range(0.8, 1)
		$BombPlaceSFX.play()
		
		var bomb = BOMB.instance()
		
		bomb.position = $BombSpawn.global_position
		
		$"../Bombs".add_child(bomb)
		
		bomb.connect("exploded", self, "_on_Bomb_explosion")
		
		$"BombBar".show()
		
		bar_progress = 0
		tween.interpolate_property(self, "bar_progress", 0, 100, $BombCooldownTimer.wait_time)
		
		if not tween.is_active():
			tween.start()
		
		$BombCooldownTimer.start()


func _physics_process(delta):
	$BombBar/BarFill.value = bar_progress


func turn_around(direction):
	if direction == 1:
		$AnimatedSprite.flip_h = false
		$Hurtbox.position.x = abs($Hurtbox.position.x)
		$PunchHitbox.position.x = abs($PunchHitbox.position.x)
		$DoorHitbox.position.x = abs($DoorHitbox.position.x)
		$CollisionShape2D.position.x = abs($CollisionShape2D.position.x)
		$CollisionShape2D2.position.x = abs($CollisionShape2D2.position.x)
		
	elif direction == -1:
		$AnimatedSprite.flip_h = true
		$Hurtbox.position.x = -1 * abs($Hurtbox.position.x)
		$PunchHitbox.position.x = -1 * abs($PunchHitbox.position.x)
		$DoorHitbox.position.x = -1 * abs($DoorHitbox.position.x)
		$CollisionShape2D.position.x = -1 * abs($CollisionShape2D.position.x)
		$CollisionShape2D2.position.x = -1 * abs($CollisionShape2D2.position.x)


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
	$BombBar.hide()


func _on_Bomb_explosion():
	bombs_left = bombs_left + 1
