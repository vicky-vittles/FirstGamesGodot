extends KinematicBody2D

const TILE_SIZE = 16
export (int) var HORIZONTAL_DISTANCE_IN_ONE_SECOND = 6
onready var SPEED = TILE_SIZE * HORIZONTAL_DISTANCE_IN_ONE_SECOND

var velocity = Vector2()

func turn_around(direction):
	if direction == 1:
		$Sprite.flip_h = false
		$CollisionShape2D.position.x = abs($CollisionShape2D.position.x)
	elif direction == -1:
		$Sprite.flip_h = true
		$CollisionShape2D.position.x = -1 * abs($CollisionShape2D.position.x)
