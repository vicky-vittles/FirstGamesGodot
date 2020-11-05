extends Area2D

const TILE_SIZE = 16
const KICK_DISTANCE_COVERED_IN_ONE_SECOND = 2.5*TILE_SIZE
var KICK_DURATION
var KICK_SPEED

var velocity = Vector2()

func activate(direction):
	KICK_DURATION = $LifetimeTimer.wait_time
	KICK_SPEED = KICK_DISTANCE_COVERED_IN_ONE_SECOND / KICK_DURATION
	
	show()
	velocity.x = sign(direction) * KICK_SPEED
	
	if direction == -1:
		$Sprite.flip_h = true
	
func _physics_process(delta):
	position += velocity * delta

func _on_LifetimeTimer_timeout():
	velocity = Vector2()
	hide()
	queue_free()
