extends Node2D

const TILE_SIZE = 16
const PUNCH_DISTANCE_COVERED_IN_ONE_SECOND = TILE_SIZE
var PUNCH_DURATION
var PUNCH_SPEED

var direction
var velocity = Vector2()


func _ready():
	$Hitbox.hit.team = "player_attack"
	$Hitbox.connect("hit_landed", self, "_on_hit_landed")


func activate(start_direction):
	direction = start_direction
	PUNCH_DURATION = $LifetimeTimer.wait_time
	PUNCH_SPEED = PUNCH_DISTANCE_COVERED_IN_ONE_SECOND / PUNCH_DURATION
	
	show()
	velocity.x = sign(start_direction) * PUNCH_SPEED
	
	if start_direction == -1:
		$Sprite.flip_h = true


func _physics_process(delta):
	position += velocity * delta


func _on_LifetimeTimer_timeout():
	velocity = Vector2()
	hide()
	queue_free()


func _on_Hitbox_body_entered(body):
	if body is TileMap:
		queue_free()


func _on_hit_landed(area):
	if area.is_in_group("protector"):
		queue_free()
